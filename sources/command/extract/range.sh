function command_extract_range()
{
    if (( $# < 3 )); then
        cat <<TEXT
Extract a specific range of pages (e.g., 1-5) into a new PDF

Usage:
  pdfmt extract range <input file> <range> <output file>

Examples:
  pdfmt extract range input.pdf 1-4,8,10-12 output.pdf
  (This will create a PDF containing ONLY these pages)

TEXT
        return 0
    fi

    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"
    local -r extract_ranges="${2:-}"
    local -r output_file="${3:-}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_file "${input_file}" || return $?
    _assert_is_not_file "${output_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"

    local expanded_pages
    if ! expanded_pages=$(_pdf_parse_ranges "${extract_ranges}" "${num_pages}"); then
        _log_error "Invalid range provided. Aborting extraction."
        return 1
    fi

    local -a pages_array=()
    read -ra pages_array <<< "${expanded_pages}" || true
    if (( ${#pages_array[@]} == 0 )); then
        _log_error "No valid pages selected for extraction."
        return 1
    fi

    pdftk "${input_file}" cat "${pages_array[@]}" output "${output_file}"
}
