function command_sort_swap()
{
    if (( $# < 4 )); then
        cat <<TEXT
Swap two specific pages within a PDF

Usage:
  pdfmt sort swap <input file> <page a> <page b> <output file>

Example:
  pdfmt sort swap input.pdf 7 2 output.pdf
  (Swaps page 7 with page 2; all other pages stay in place)

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"
    local -r page_a="${2:-}"
    local -r page_b="${3:-}"
    local -r output_file="${4:-}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_file "${input_file}" || return $?
    _assert_is_digit "${page_a}" || return $?
    _assert_is_digit "${page_b}" || return $?
    _assert_is_not_file "${output_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"

    if (( page_a > num_pages || page_b > num_pages || page_a < 1 || page_b < 1 )); then
        _log_error "One or both page numbers ($page_a, $page_b) are out of range (1-$num_pages)."
        return 1
    fi

    local new_order=""
    for (( i=1; i<=num_pages; i++ )); do
        if (( i == page_a )); then
            new_order="${new_order} ${page_b}"
        elif (( i == page_b )); then
            new_order="${new_order} ${page_a}"
        else
            new_order="${new_order} ${i}"
        fi
    done

    local -r final_pages="$(echo "$new_order" | xargs)"

    # shellcheck disable=SC2086  # final_pages: "pdftk ... cat" requires page numbers as a space separated list
    pdftk "${input_file}" cat $final_pages output "${output_file}"
}
