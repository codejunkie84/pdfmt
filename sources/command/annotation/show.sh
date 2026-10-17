function command_annotation_show()
{
    if (( $# < 1 )); then
        cat <<TEXT
Show annotation details into plain text format

Usage:
  pdfmt annotation show <input file> [type]

Types:
  all         Show all annotations

  Exact Subtypes (comma-separated):
    highlight, underline, strikeout, squiggly,
    text, freetext, popup, link,
    square, circle, line, ink, stamp

  Aliases:
    highlights  (highlight, underline, strikeout, squiggly)
    comments    (text, freetext, popup, ink, square, circle, line, stamp)
    links       (link)

Examples:
  pdfmt annotation show input.pdf all
  pdfmt annotation show input.pdf text,link

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"
    local -r raw_types="${2:-all}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_installed qpdf || return $?
    _assert_is_installed jq || return $?
    _assert_is_file "${input_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    # Parse comma-separated types (supports both raw Subtypes and Aliases)
    local target_subtypes=()
    local types_array=()
    local type_item clean_type

    if [[ "${raw_types}" == "all" ]]; then
        target_subtypes+=(
            "/Circle"
            "/FreeText"
            "/Highlight"
            "/Ink"
            "/Line"
            "/Link"
            "/Popup"
            "/Square"
            "/Squiggly"
            "/Stamp"
            "/StrikeOut"
            "/Text"
            "/Underline"
        )
    else
        IFS=',' read -r -a types_array <<< "${raw_types}"
        for type_item in "${types_array[@]}"; do
            clean_type="$(printf '%s' "${type_item}" | xargs | tr '[:upper:]' '[:lower:]')"
            case "${clean_type}" in
                # alias types
                highlights) target_subtypes+=("/Highlight" "/Underline" "/StrikeOut" "/Squiggly") ;;
                comments)   target_subtypes+=("/Text" "/FreeText" "/Popup" "/Ink" "/Square" "/Circle" "/Line" "/Stamp") ;;

                # regular types
                circle)     target_subtypes+=("/Circle") ;;
                freetext)   target_subtypes+=("/FreeText") ;;
                highlight)  target_subtypes+=("/Highlight") ;;
                ink)        target_subtypes+=("/Ink") ;;
                line)       target_subtypes+=("/Line") ;;
                link)       target_subtypes+=("/Link") ;;
                links)      target_subtypes+=("/Link") ;;
                popup)      target_subtypes+=("/Popup") ;;
                square)     target_subtypes+=("/Square") ;;
                squiggly)   target_subtypes+=("/Squiggly") ;;
                stamp)      target_subtypes+=("/Stamp") ;;
                strikeout)  target_subtypes+=("/StrikeOut") ;;
                text)       target_subtypes+=("/Text") ;;
                underline)  target_subtypes+=("/Underline") ;;
                *)
                    _log_error "Unknown annotation type or subtype '${type_item}'."
                    return 1
                    ;;
            esac
        done
    fi

    # Prepare target JSON array
    local targets_json
    targets_json="$(printf '%s\n' "${target_subtypes[@]}" | jq -R . | jq -s .)" || return 1

    # Extract plain text representation
    local extracted_text

    if ! extracted_text=$(qpdf --json "${input_file}" |
        jq -r --argjson targets "${targets_json}" '
            # Map: qpdf-Page-Object -> Page number
            (
                [
                    .pages[]
                    | {
                        key: ("obj:" + .object),
                        value: .pageposfrom1
                    }
                ] | from_entries
            ) as $page_map

            # Map: Annotation-Object-ID -> Page number
            | (
                [
                    .qpdf[1]
                    | to_entries[]
                    | select(.value.value?."/Type"? == "/Page")
                    | .key as $page_object
                    | ($page_map[$page_object] // null) as $page_num
                    | select($page_num != null)
                    | (.value.value?."/Annots"? // [])[]
                    | select(type == "string")
                    | {
                        key: sub("^obj:"; ""),
                        value: $page_num
                    }
                ] | from_entries
            ) as $annot_pages

            # Print annotation
            | [
                .qpdf[1]
                | to_entries[]
                | select(.value.value?."/Type"? == "/Annot")
                | select(
                    .value.value?."/Subtype"? as $st
                    | ($targets | index($st)) != null
                )
                | (.key | sub("^obj:"; "")) as $annot_id
                | .value.value as $a
                | ($annot_pages[$annot_id] // null) as $page_num
                | select($page_num != null)
                | ($a."/Subtype" | sub("^/"; "")) as $st_name
                | ($a."/T"? // "" | sub("^u:"; "")) as $author
                | ($a."/Contents"? // "" | sub("^u:"; "")) as $content
                | ($a."/A"?."/URI"? // "" | sub("^u:"; "")) as $uri
                | ($a."/Rect"? // []) as $rect

                | "Page " + ($page_num | tostring)
                  + ": " + $st_name
                  + (if $author != ""
                     then ", Author: " + $author else "" end)
                  + (if $content != ""
                     then ", Content: \"" + $content + "\"" else "" end)
                  + (if $uri != ""
                     then ", URL: " + $uri else "" end)
                  + (if $content == "" and $uri == ""
                     then ", Rect: " + ($rect | tostring) else "" end)
            ]
            | if length == 0 then
                "No matching annotations found."
              else
                join("\n")
              end
        '); then
        _log_error "Failed to show annotations from PDF."
        return 1
    fi

    printf '%s\n' "${extracted_text}"
}
