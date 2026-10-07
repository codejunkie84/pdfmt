function command_ocr_add()
{
    if (( $# < 2 )); then
        cat <<TEXT
Add an OCR text layer to a PDF document

Usage:
  pdfmt ocr add <input file> <output file>

Examples:
  pdfmt ocr add input.pdf output.pdf

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    _config_load_ocr

    local -r input_file="${1:-}"
    local -r output_file="${2:-}"
    local -r language="${OCR_LANGUAGE:-eng}"
    local -r plugin="${OCR_PLUGIN:-}"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_installed ocrmypdf || return $?
    _assert_is_file "${input_file}" || return $?
    _assert_is_not_file "${output_file}" || return $?
    _assert_matches_regex '^[a-z]{3}$' "${language}" "Invalid language format: ${language}" || return $?

    if [[ -n "${plugin}" ]]; then
        if ! ocrmypdf --plugin "${plugin}" --help &>/dev/null; then
            _log_error "OCRmyPDF plugin is not installed or invalid: '${plugin}'" >&2
            return 1
        fi
    fi


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    # Skip OCR if the PDF already contains extractable text.
    # Extract text stream and test if at least one alphanumeric character exists,
    if pdftotext -enc UTF-8 "${input_file}" - 2>/dev/null | grep -q '[[:alnum:]]'; then
        return 0
    fi

    # build options
    local opts=(-l "${language}")
    if [[ -n "${plugin}" && "${plugin}" != "tesseract" ]]; then
        opts+=(--plugin "${plugin}")
    fi

    ocrmypdf "${opts[@]}" "${input_file}" "${output_file}"
}
