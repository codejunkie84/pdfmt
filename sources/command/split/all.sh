function command_split_all()
{
    if (( $# < 1 )); then
        cat <<TEXT
Split a PDF into separate files, one for each page

Usage:
  pdfmt split all <input file> [output prefix]

Examples:
  pdfmt split all input.pdf
  pdfmt split all input.pdf prefix_

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"
    local -r output_prefix="${2:-$(basename "${input_file%.*}")_}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_file "${input_file}" || return $?

    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"
    for ((i=1; i<=num_pages; i++)); do
        local output_file="${output_prefix}${i}.pdf"

        _assert_is_not_file "${output_file}" || return $?
    done


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r temp_dir="$(mktemp -d)"
    FILES_TO_CLEANUP+=("${temp_dir}")


    # Split
    for ((i=1; i<=num_pages; i++)); do
        local output_file="${output_prefix}${i}.pdf"
        local temp_file="${temp_dir}/${i}.pdf"

        _log_info "Creating ${output_file} with page ${i} ..."
        pdftk "${input_file}" cat "${i}" output "${temp_file}"
    done


    # Move
    for ((i=1; i<=num_pages; i++)); do
        local output_file="${output_prefix}${i}.pdf"
        local temp_file="${temp_dir}/${i}.pdf"

        mv "${temp_file}" "${output_file}"
    done
}
