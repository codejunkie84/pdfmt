function command_merge_insert()
{
    if (( $# < 4 )); then
        cat <<TEXT
Insert a PDF into another document at a specific page

Usage:
  pdfmt merge insert <input file> <position> <insert file> <output file>

Examples:
  pdfmt merge insert book.pdf 2 toc.pdf output.pdf

TEXT
        return 0
    fi

    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"
    local -r position="${2:-}"
    local -r insert_file="${3:-}"
    local -r output_file="${4:-}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_file "${input_file}" || return $?
    _assert_is_digit "${position}" || return $?
    _assert_is_file "${insert_file}" || return $?
    _assert_is_not_file "${output_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"

    local range_before=""
    local range_after=""
    if (( position <= 1 )); then
        range_after="A1-end"
    elif (( position > num_pages )); then
        range_before="A1-end"
    else
        range_before="A1-$((position - 1))"
        range_after="A${position}-end"
    fi

    pdftk A="${input_file}" B="${insert_file}" cat "$range_before" B "$range_after" output "${output_file}"
}
