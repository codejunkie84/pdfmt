function command_sort_reverse()
{
    if (( $# < 2 )); then
        cat <<TEXT
Reverse the page order of a PDF

Usage:
  pdfmt sort reverse <input file> <output file>

Examples:
  pdfmt sort reverse input.pdf output.pdf

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"
    local -r output_file="${2:-}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_file "${input_file}" || return $?
    _assert_is_not_file "${output_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    pdftk "$input_file" cat end-1 output "$output_file"
}
