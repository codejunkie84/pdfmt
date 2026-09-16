function command_sort_random()
{
    if (( $# < 2 )); then
        cat <<TEXT
Shuffle the pages of a PDF into a random order

Usage:
  pdfmt sort random <input file> <output file>

Examples:
  pdfmt sort random input.pdf output.pdf

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
    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"
    local -r random_pages=$(seq 1 "$num_pages" | awk 'BEGIN { srand(); } { print rand() "\t" $0 }' | sort -n | cut -f2- | tr '\n' ' ')

    read -ra pages_array <<< "$random_pages"
    pdftk "${input_file}" cat "${pages_array[@]}" output "${output_file}"
}
