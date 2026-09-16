function command_sort_move()
{
    if (( $# < 4 )); then
        cat <<TEXT
Move specific pages to a new position within the PDF

Usage:
  pdfmt sort move <input file> <range> <target_pos> <output file>

Examples:
  pdfmt sort move input.pdf 2-3,5,7-8 1 output.pdf
  (Moves pages 2, 3, 5, 7, and 8 to the very beginning)

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"
    local -r move_ranges="${2:-}"
    local -r target_pos="${3:-}"
    local -r output_file="${4:-}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_file "${input_file}" || return $?
    _assert_is_digit "${target_pos}" || return $?
    _assert_is_not_file "${output_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"

    local expanded_pages
    if ! expanded_pages=$(_pdf_parse_ranges "${move_ranges}" "${num_pages}"); then
        _log_error "Invalid range given"
        return 1
    fi

    local -a sel_array
    read -ra sel_array <<< "${expanded_pages}"

    local -a sel_map=()
    for sel in "${sel_array[@]}"; do
        sel_map[sel]=1
    done

    local -a rem_array=()
    for (( i=1; i<=num_pages; i++ )); do
        if [[ "${sel_map[i]:-0}" != "1" ]]; then
            rem_array+=("$i")
        fi
    done

    local -a final_order=()
    local rem_count=${#rem_array[@]}

    if (( target_pos <= 1 )); then
        final_order=("${sel_array[@]}" "${rem_array[@]}")
    elif (( target_pos > rem_count )); then
        final_order=("${rem_array[@]}" "${sel_array[@]}")
    else
        local idx=$((target_pos - 1))
        final_order=(
            "${rem_array[@]:0:idx}"
            "${sel_array[@]}"
            "${rem_array[@]:idx}"
        )
    fi

    pdftk "${input_file}" cat "${final_order[@]}" output "${output_file}"
}
