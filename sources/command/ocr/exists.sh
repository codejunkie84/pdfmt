function command_ocr_exists()
{
    if (( $# < 1 )); then
        cat <<TEXT
Check if a PDF document contains an OCR/text layer

Usage:
  pdfmt ocr exists <input file>

Examples:
  pdfmt ocr exists document.pdf

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1:-}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_installed pdftotext || return $?
    _assert_is_file "${input_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    # Extract text stream and test if at least one alphanumeric character exists.
    if pdftotext -enc UTF-8 "${input_file}" - 2>/dev/null | grep -q '[[:alnum:]]'; then
        echo "true"
        return 0
    else
        echo "false"
        return 1
    fi
}
