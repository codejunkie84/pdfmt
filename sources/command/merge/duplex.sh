function command_merge_duplex()
{
    if (( $# < 3 )); then
        cat <<TEXT
Interleave two PDFs (front/back scans) into one duplex document

Usage:
  pdfmt merge duplex <input frontside file> <input backside file> <output file>

Examples:
  pdfmt merge duplex frontside.pdf backside.pdf output.pdf

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_frontside_file="${1:-}"
    local -r input_backside_file="${2:-}"
    local -r output_file="${3:-}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_file "${input_frontside_file}" || return $?
    _assert_is_file "${input_backside_file}" || return $?
    _assert_is_not_file "${output_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r num_frontside_pages="$(_pdf_get_num_pages "${input_frontside_file}")"
    local -r num_backside_pages="$(_pdf_get_num_pages "${input_backside_file}")"
    if (( num_frontside_pages != num_backside_pages )); then
        _log_error "Number of pages differs from frontside and backside input files"
        return 1
    fi

    pdftk A="${input_frontside_file}" B="${input_backside_file}" shuffle A Bend-1 output "${output_file}"
}
