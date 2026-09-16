function command_split_length()
{
    if (( $# < 2 )); then
        cat <<TEXT
Split a PDF into chunks of a fixed number of pages

Usage:
  pdfmt split length <input file> <num pages per file> [output prefix]

Examples:
  pdfmt split length input.pdf 2
  pdfmt split length input.pdf 2 prefix_

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"
    local -r num_pages_per_file="${2:-}"
    local -r output_prefix="${3:-$(basename "${input_file%.*}")_}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_file "${input_file}" || return $?

    if ! [[ "${num_pages_per_file}" =~ ^[1-9][0-9]*$ ]]; then
        _log_error "length is not a positive number"
        return 1
    fi


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"
    local -r num_documents=$(( (num_pages + num_pages_per_file - 1) / num_pages_per_file ))

    for ((i=1; i<=num_documents; i++)); do
        local output_file="${output_prefix}${i}.pdf"

        _assert_is_not_file "${output_file}" || return $?
    done


    local -r temp_dir="$(mktemp -d)"
    FILES_TO_CLEANUP+=("${temp_dir}")


    # Split
    for ((i=0; i<num_documents; i++)); do
        local start=$(( i * num_pages_per_file + 1 ))
        local end=$(( (i + 1) * num_pages_per_file ))

        if [[ "${end}" -gt "${num_pages}" ]]; then
            end="${num_pages}"
        fi

        local output_file="${output_prefix}$((i + 1)).pdf"
        local temp_file="${temp_dir}/$((i + 1)).pdf"

        _log_info "Creating ${output_file} with page ${start}-${end} ..."
        pdftk "${input_file}" cat "${start}-${end}" output "${temp_file}"
    done


    # Move
    for ((i=1; i<=num_documents; i++)); do
        local output_file="${output_prefix}${i}.pdf"
        local temp_file="${temp_dir}/${i}.pdf"

        mv "${temp_file}" "${output_file}"
    done
}
