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
    _assert_file "${input_file}"


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"
    local output_file=""

    if ! [[ "$num_pages_per_file" =~ ^[1-9][0-9]*$ ]]; then
        _log_error "length is not a positive number"
        return 1
    fi

    local -r num_documents=$(( (num_pages + num_pages_per_file - 1) / num_pages_per_file ))
    local start=0
    local end=0
    for ((i=0; i<num_documents; i++)); do
        start=$(( i * num_pages_per_file + 1 ))
        end=$(( (i + 1) * num_pages_per_file ))
        if [[ "$end" -gt "$num_pages" ]]; then
            end=$num_pages
        fi
        output_file="${output_prefix}$((i + 1)).pdf"
        _log_info "Creating $output_file with page $start-$end ..."
        pdftk "$input_file" cat "$start-$end" output "$output_file"
    done
}
