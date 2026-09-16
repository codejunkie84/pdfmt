function command_remove_range()
{
    if (( $# < 3 )); then
        cat <<TEXT
Remove a specific range of pages (e.g., 1-5)

Usage:
  pdfmt remove range <input file> <range> <output file>

Examples:
  pdfmt remove range input.pdf 1-4,5,7-12 output.pdf
  (This would remove pages 1 to 4, page 5, and pages 7 to 12)

TEXT
        return 0
    fi

    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"
    local -r remove_ranges="${2:-}"
    local -r output_file="${3:-}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_file "${input_file}" || return $?
    _assert_is_not_file "${output_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"

    local expanded_pages
    if ! expanded_pages=$(_pdf_parse_ranges "${remove_ranges}" "${num_pages}"); then
        _log_error "Invalid range provided. Aborting."
        return 1
    fi

    local -a pages_to_remove
    read -ra pages_to_remove <<< "${expanded_pages}"

    local -a remove_map=()
    for p in "${pages_to_remove[@]}"; do
        remove_map[p]=1
    done

    local -a keep_array=()
    for (( i=1; i<=num_pages; i++ )); do
        if [[ "${remove_map[i]:-0}" != "1" ]]; then
            keep_array+=("$i")
        fi
    done

    if (( ${#keep_array[@]} == 0 )); then
        _log_error "You removed all pages! Resulting PDF would be empty."
        return 1
    fi

    pdftk "${input_file}" cat "${keep_array[@]}" output "${output_file}"
}
