function command_sort_duplex()
{
    if (( $# < 2 )); then
        cat <<TEXT
Reorder a single PDF containing consecutive front and back scans

Usage:
  pdfmt sort duplex <input file> <output file>

Examples:
  pdfmt sort duplex input.pdf output.pdf

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"
    local -r output_file="${2:-}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_file "${input_file}" || return $?
    _assert_is_not_file "${output_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r num_pages="$(_pdf_get_num_pages "${input_file}")"
    if (( num_pages % 2 != 0 )); then
        _log_error "Odd number of pages. Total pages: $num_pages"
        return 1
    fi

    # Halve the number of pages
    local -r half=$((num_pages / 2))

    # Temp files
    local -r odd_pages="$(_create_temp_file .pdf)"
    local -r even_pages="$(_create_temp_file .pdf)"
    FILES_TO_CLEANUP+=("$odd_pages")
    FILES_TO_CLEANUP+=("$even_pages")

    # First half: Front pages (1 to half)
    # Second half: Back pages (half+1 to pages), but in reverse order
    pdftk "$input_file" cat "1-$half" output "$odd_pages"
    pdftk "$input_file" cat "$((half + 1))-$num_pages" output "$even_pages"

    # The backsides are scanned upside down, so Bend-1
    pdftk A="$odd_pages" B="$even_pages" shuffle A Bend-1 output "$output_file"
}
