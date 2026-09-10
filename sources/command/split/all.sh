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
    _assert_file "${input_file}"


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"
    local output_file=""

    for ((i=1; i<=num_pages; i++)); do
        output_file="${output_prefix}${i}.pdf"
        _log_info "Creating $output_file with page $i ..."
        pdftk "$input_file" cat "$i" output "$output_file"
    done
}
