function command_remove_odd()
{
    if (( $# < 2 )); then
        cat <<TEXT
Remove all odd-numbered pages

Usage:
  pdfmt remove odd <input file> <output file>

Examples:
  pdfmt remove odd input.pdf output.pdf

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
    if (( num_pages < 2 )); then
        _log_error "PDF has only 1 page. Removing odd pages would leave it empty."
        return 1
    fi

    local -r keep_pages=$(seq 2 2 "${num_pages}" | tr '\n' ' ')

    read -ra pages_array <<< "$keep_pages"
    pdftk "${input_file}" cat "${pages_array[@]}" output "${output_file}"
}
