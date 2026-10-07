function command_ocr_show()
{
    if (( $# < 1 )); then
        cat <<TEXT
Display the extracted OCR text layer of a PDF document

Usage:
  pdfmt ocr show <input file>

Examples:
  pdfmt ocr show document.pdf

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
    pdftotext -enc UTF-8 "${input_file}" -
}
