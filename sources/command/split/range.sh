function command_split_range()
{
    if (( $# < 2 )); then
        cat <<TEXT
Split a PDF into multiple files based on page ranges

Usage:
  pdfmt split range <input file> <range 1> [<range 2> ...] [output prefix]

Examples:
  pdfmt split range input.pdf 1-4,6,7-8 1-3,5
  pdfmt split range input.pdf 1-4,6,7-8 1-3,5 prefix_

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"
    shift
    local -a args=("$@")


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_file "${input_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"

    local output_prefix=""
    local -a ranges=()

    # Check whether an optional prefix was passed (the last argument is not a valid range)
    if (( ${#args[@]} >= 2 )); then
        local -r last_arg="${args[-1]}"

        if _pdf_parse_ranges "${last_arg}" "${num_pages}" >/dev/null 2>&1; then
            # The last argument is a valid range -> All arguments are ranges; use the default prefix
            ranges=("${args[@]}")
            output_prefix="$(basename "${input_file%.*}")_"
        else
            # The last argument is not a valid range -> It is the optional output prefix
            output_prefix="${last_arg}"
            ranges=("${args[@]:0:$(( ${#args[@]} - 1 ))}")
        fi
    else
        # Only 1 argument after the file -> Must be a range; use the default prefix
        ranges=("${args[@]}")
        output_prefix="$(basename "${input_file%.*}")_"
    fi


    # Validate ranges and output files
    local count=1

    for range_string in "${ranges[@]}"; do
        local expanded_pages

        if ! expanded_pages=$(_pdf_parse_ranges "${range_string}" "${num_pages}"); then
            _log_error "Invalid range '${range_string}' provided. Aborting."
            return 1
        fi

        local -a pages_array=()
        read -ra pages_array <<< "${expanded_pages}" || true

        if (( ${#pages_array[@]} == 0 )); then
            _log_error "No valid pages selected for range '${range_string}'."
            return 1
        fi

        local output_file="${output_prefix}${count}.pdf"
        _assert_is_not_file "${output_file}" || return $?

        ((count++))
    done


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r temp_dir="$(mktemp -d)"
    FILES_TO_CLEANUP+=("${temp_dir}")


    # Split
    # -----------------------------------------------------------------------------------------------------------------
    count=1

    for range_string in "${ranges[@]}"; do
        local expanded_pages
        expanded_pages=$(_pdf_parse_ranges "${range_string}" "${num_pages}")

        local -a pages_array=()
        read -ra pages_array <<< "${expanded_pages}" || true

        local output_file="${output_prefix}${count}.pdf"
        local temp_file="${temp_dir}/${count}.pdf"

        _log_info "Creating ${output_file} with pages ${range_string} ..."
        pdftk "${input_file}" cat "${pages_array[@]}" output "${temp_file}"

        ((count++))
    done


    # Move
    # -----------------------------------------------------------------------------------------------------------------
    count=1

    for range_string in "${ranges[@]}"; do
        local output_file="${output_prefix}${count}.pdf"
        local temp_file="${temp_dir}/${count}.pdf"

        mv "${temp_file}" "${output_file}"

        ((count++))
    done
}
