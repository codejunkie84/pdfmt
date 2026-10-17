#!/usr/bin/env bash
# =====================================================================================================================
# Script: generate-pdf-pages.sh
#
# Description:
# Generates a multi-page A4 PDF fixture with centered text per page and cleared internal metadata using Ghostscript.
#
# Usage:
# ./generate-pdf-pages.sh <font.ttf> <output.pdf> <page_text_1> [page_text_2 ...]
#
# Examples:
# ./generate-pdf-pages.sh DejaVuSans-Bold.ttf output.pdf 1 3 5 7
# ./generate-pdf-pages.sh DejaVuSans-Bold.ttf output.pdf "seite 1" "das auf die 2. seite"
# =====================================================================================================================
set -euo pipefail

function main()
{
    if (( $# < 2 )); then
        echo "Usage:   $0 <font.ttf> <output.pdf> <page_text_1> [page_text_2 ...]" >&2
        echo "Example: $0 DejaVuSans-Bold.ttf output.pdf 1 3 5 7" >&2
        return 1
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r font_file="${1}"
    local -r output_pdf="${2}"
    shift
    shift

    local -r font_directory="$(dirname "$font_file")"
    local -r font_name="$(basename "${font_file%.*}")"


    # Verify
    # -----------------------------------------------------------------------------------------------------------------
    if [[ ! -f "${font_file}" ]]; then
        echo "ERROR: Font file not found at ${font_file}" >&2
        return 1
    fi


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    # Dynamically build PostScript content from script arguments
    local ps_pages=""
    for text in "$@"; do
        ps_pages+="
          /${font_name} findfont 64 scalefont setfont
          297.5 (${text}) stringwidth pop 2 div sub 720 moveto (${text}) show
          showpage
        "
    done

    # Feed the generated PostScript code via stdin to Ghostscript (with stripped metadata)
    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
        -sPAPERSIZE=a4 \
        -dFIXEDMEDIA \
        -dPDFFitPage \
        -sFONTPATH="${font_directory}" \
        -sOutputFile="${output_pdf}" - << EOF
% Strip / suppress internal PDF document metadata
% =====================================================================================================================
[
    /Title ()
    /Author ()
    /Subject ()
    /Keywords ()
    /Creator ()
    /Producer ()
    /CreationDate ()
    /ModDate ()
    /DOCINFO pdfmark

% Print pages
% =====================================================================================================================
${ps_pages}
EOF
}

main "$@"
