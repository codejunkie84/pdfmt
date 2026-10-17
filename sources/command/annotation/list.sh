function command_annotation_list()
{
    if (( $# < 1 )); then
        cat <<TEXT
List all annotation types present in a PDF document

Usage:
  pdfmt annotation list <input file>

Examples:
  pdfmt annotation list input.pdf

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_installed qpdf || return $?
    _assert_is_installed jq || return $?
    _assert_is_file "${input_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local annots
    annots=$(qpdf --json "${input_file}" | jq -r '
        ..
        | objects
        | select(."/Type"? == "/Annot")
        | ."/Subtype"?
        | select(. != null)
    ' 2>/dev/null)

    if [[ -z "${annots}" ]]; then
        echo "No annotations found in '${input_file}'."
        return 0
    fi

    echo "Annotations found in '${input_file}':"
    echo "${annots}" \
        | sed 's/^\///' \
        | sort \
        | uniq -c \
        | awk '{printf "  - %-15s (count: %d)\n", $2, $1}'
}
