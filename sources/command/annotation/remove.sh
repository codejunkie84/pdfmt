function command_annotation_remove()
{
    if (( $# < 3 )); then
        cat <<TEXT
Remove annotations from a PDF document

Usage:
  pdfmt annotation remove <input file> <type> <output file>

Types:
  all         Remove all supported annotation subtypes

  Exact Subtypes (comma-separated):
    highlight, underline, strikeout, squiggly,
    text, freetext, popup, link,
    square, circle, line, ink, stamp

  Aliases:
    highlights  (highlight, underline, strikeout, squiggly)
    comments    (text, freetext, popup, ink, square, circle, line, stamp)
    links       (link)

Examples:
  pdfmt annotation remove input.pdf all output.pdf
  pdfmt annotation remove input.pdf circle output.pdf
  pdfmt annotation remove input.pdf text,link,underline output.pdf

TEXT
        return 0
    fi

    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1}"
    local -r raw_types="${2}"
    local -r output_file="${3}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_installed qpdf || return $?
    _assert_is_installed jq || return $?
    _assert_is_file "${input_file}" || return $?
    _assert_is_not_file "${output_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    # Parse annotation types
    local -a target_subtypes=()
    local -a types_array=()
    local type_item clean_type

    if [[ "${raw_types}" == "all" ]]; then
        target_subtypes=(
            "/Highlight"
            "/Underline"
            "/StrikeOut"
            "/Squiggly"
            "/Text"
            "/FreeText"
            "/Popup"
            "/Link"
            "/Square"
            "/Circle"
            "/Line"
            "/Ink"
            "/Stamp"
            "/Widget"
            "/Caret"
            "/FileAttachment"
            "/Sound"
            "/Movie"
            "/Screen"
            "/PrinterMark"
            "/TrapNet"
            "/Watermark"
            "/3D"
            "/Redact"
        )
    else
        IFS=',' read -r -a types_array <<< "${raw_types}"

        for type_item in "${types_array[@]}"; do
            clean_type="$(
                printf '%s' "${type_item}" |
                    xargs |
                    tr '[:upper:]' '[:lower:]'
            )"

            case "${clean_type}" in
                # alias types
                highlights) target_subtypes+=("/Highlight" "/Underline" "/StrikeOut" "/Squiggly") ;;
                comments)   target_subtypes+=("/Text" "/FreeText" "/Popup" "/Ink" "/Square" "/Circle" "/Line" "/Stamp") ;;
                links)      target_subtypes+=("/Link") ;;

                # regular types
                highlight) target_subtypes+=("/Highlight") ;;
                underline) target_subtypes+=("/Underline") ;;
                strikeout) target_subtypes+=("/StrikeOut") ;;
                squiggly)  target_subtypes+=("/Squiggly") ;;
                text)      target_subtypes+=("/Text") ;;
                freetext)  target_subtypes+=("/FreeText") ;;
                popup)     target_subtypes+=("/Popup") ;;
                link)      target_subtypes+=("/Link") ;;
                square)    target_subtypes+=("/Square") ;;
                circle)    target_subtypes+=("/Circle") ;;
                line)      target_subtypes+=("/Line") ;;
                ink)       target_subtypes+=("/Ink") ;;
                stamp)     target_subtypes+=("/Stamp") ;;
                *)
                    _log_error \
                        "Unknown annotation type or subtype '${type_item}'."
                    return 1
                    ;;
            esac
        done
    fi

    # Build JSON array of target subtypes
    local targets_json
    targets_json="$(
        printf '%s\n' "${target_subtypes[@]}" |
            jq -R . |
            jq -s .
    )" || {
        _log_error "Failed to build annotation subtype list."
        return 1
    }

    # Create temporary JSON file
    local json_tmp
    json_tmp="$(mktemp)" || {
        _log_error "Failed to create temporary file."
        return 1
    }

    # Remove annotation references from /Annots arrays.
    # Keep all other PDF objects intact.
    if ! qpdf --json "${input_file}" |
        jq --argjson targets "${targets_json}" '
            # Find matching annotation object IDs.
            ([
                .qpdf[1]
                | to_entries[]
                | select(.value.value?."/Type"? == "/Annot")
                | select(
                    .value.value?."/Subtype"? as $subtype
                    | ($targets | index($subtype)) != null
                )
                | .key
                | sub("^obj:"; "")
            ]) as $annotation_ids

            # Remove matching references from every /Annots array.
            | walk(
                if type == "object"
                   and (."/Annots"? | type) == "array"
                then
                    ."/Annots" |= map(
                        if type == "string" then
                            select(
                                (
                                    . as $ref
                                    | ($annotation_ids | index(
                                        ($ref | sub("^obj:"; ""))
                                      ))
                                ) == null
                            )
                        else
                            select(
                                if type == "object" then
                                    (
                                        . as $ref
                                        | ($annotation_ids | index(
                                            ($ref | tostring | sub("^obj:"; ""))
                                          ))
                                    ) == null
                                else
                                    true
                                end
                            )
                        end
                    )
                else
                    .
                end
            )
        ' > "${json_tmp}"; then
        rm -f "${json_tmp}"
        _log_error "Failed to filter annotations from qpdf JSON."
        return 1
    fi

    # Rebuild PDF from modified JSON
    if ! qpdf --update-from-json="${json_tmp}" \
        "${input_file}" "${output_file}" 2>/dev/null; then
        rm -f "${json_tmp}"
        _log_error "Failed to write output PDF."
        return 1
    fi

    rm -f "${json_tmp}"
    return 0
}
