function command_merge_all()
{
    if (( $# < 3 )); then
        cat <<TEXT
Combine PDFs into a single document

Usage:
  pdfmt merge all <input file 1> <input file 2> [input file ...] <output file>

Examples:
  pdfmt merge all cover.pdf toc.pdf chapter1.pdf chapter2.pdf output.pdf

TEXT
        return 0
    fi

    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r args=("$@")
    local -r output_file="${args[-1]}"
    local -r input_files=("${args[@]:0:${#args[@]}-1}")



    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    for input_file in "${input_files[@]}"; do
        _assert_is_file "$input_file" || return $?
    done
    _assert_is_not_file "${output_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    pdftk "${input_files[@]}" cat output "$output_file"
}
