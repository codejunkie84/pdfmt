function command_stamp_text()
{
    if (( $# < 3 )); then
        cat <<TEXT
Add a custom text stamp to a PDF

Usage:
  pdfmt stamp text <input file> <text> <output file>

Examples:
  pdfmt stamp text input.pdf "invoice paid on 20.07.2027" output.pdf

TEXT
        return 0
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    _config_load_stamp_text


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    local -r please_check="Please check ~/.config/pdfmt/stamp_text.conf"
    _assert_is_not_empty "${STAMP_TEXT_FONT_FILE}" "No font file configured. $STAMP_TEXT_FONT_FILE ${please_check}" || return $?
    _assert_is_not_empty "${STAMP_TEXT_FONT_COLOR}" "No font color configured. ${please_check}" || return $?
    _assert_is_file "${STAMP_TEXT_FONT_FILE}" "Configured font file not found: '${STAMP_TEXT_FONT_FILE}'. ${please_check}" || return $?
    _assert_is_digit "${STAMP_TEXT_FONT_SIZE}" "Configured font size is invalid: '${STAMP_TEXT_FONT_SIZE}'. ${please_check}" || return $?

    local -r input_file="${1:-}"
    local -r text="${2:-}"
    local -r output_file="${3:-}"

    _assert_is_file "${input_file}" || return $?
    _assert_is_not_file "${output_file}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    # Temp file for stamp
    local -r stamp_file="$(_create_temp_file .pdf)"
    FILES_TO_CLEANUP+=("$stamp_file")

    # read dimensions with 72 DPI and scale up to 600 DPI (fastest solution)
    IFS=x read -r width72 height72 < <(identify -format '%wx%h\n' "${input_file}[0]")

    local -r width=$(awk "BEGIN {print int(${width72} * 600 / 72 + 0.5)}")
    local -r height=$(awk "BEGIN {print int(${height72} * 600 / 72 + 0.5)}")

    # create the stamp
    convert -density 600 -size "${width}x${height}" xc:transparent \
      -font "${STAMP_TEXT_FONT_FILE}" \
      -pointsize "${STAMP_TEXT_FONT_SIZE}" \
      -fill "#444444" -gravity NorthEast -annotate +356+364 "${text}" \
      -fill "${STAMP_TEXT_FONT_COLOR}" -gravity NorthEast -annotate +360+360 "${text}" \
      "${stamp_file}"

    # stamp
    pdftk "${input_file}" stamp "${stamp_file}" output "${output_file}"
}
