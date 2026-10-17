#!/usr/bin/env bash
# =====================================================================================================================
# Script: generate-pdf-annotation.sh
#
# Description:
# Generates a multi-page A4 PDF fixture containing various PDF annotations (Text, FreeText, Highlight, Underline,
# StrikeOut, Squiggly, Link, Square, Circle, Line, Ink, Stamp) along with visual markers and cleared internal metadata.
#
# Usage:
# ./generate-pdf-annotation.sh <font.ttf> <output.pdf>
#
# Example:
# ./generate-pdf-annotation.sh DejaVuSans-Bold.ttf output.pdf
# =====================================================================================================================
set -euo pipefail

function main()
{
    if (( $# < 1 )); then
        echo "Usage:   $0 <font.ttf> <output.pdf>" >&2
        echo "Example: $0 DejaVuSans-Bold.ttf output.pdf" >&2
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

% PAGE 1: Text Markups & Sticky Notes
% -----------------------------------------------------------------------------
/${font_name} findfont 11 scalefont setfont

50 780 moveto (pdfmt Test Fixture - Page 1: Text Markups & Notes) show
50 720 moveto (Highlight text) show
50 660 moveto (Underline text) show
50 600 moveto (Strikeout text) show
50 540 moveto (Squiggly text) show

% Annotations
[ /Subtype /Highlight /Rect [50 715 200 735] /QuadPoints [50 735 200 735 50 715 200 715] /Color [1 1 0] /ANN pdfmark
[ /Subtype /Underline /Rect [50 655 200 675] /QuadPoints [50 675 200 675 50 655 200 655] /Color [0 1 0] /ANN pdfmark
[ /Subtype /StrikeOut /Rect [50 595 200 615] /QuadPoints [50 615 200 615 50 595 200 595] /Color [1 0 0] /ANN pdfmark
[ /Subtype /Squiggly  /Rect [50 535 200 555] /QuadPoints [50 555 200 555 50 535 200 535] /Color [1 0.5 0] /ANN pdfmark
[ /Subtype /Text /Rect [250 715 270 735] /Title (Reviewer) /Contents (Sticky note comment) /ANN pdfmark
[ /Subtype /FreeText /Rect [250 655 400 685] /Contents (FreeText Box) /Color [0.9 0.9 0.9] /ANN pdfmark

showpage


% PAGE 2: Links & Shapes
% -----------------------------------------------------------------------------
/${font_name} findfont 11 scalefont setfont

50 780 moveto (pdfmt Test Fixture - Page 2: Links & Geometric Shapes) show
50 720 moveto (Link to website) show

% Visible box for Link
newpath 50 715 moveto 200 715 lineto 200 735 lineto 50 735 lineto closepath stroke
50 740 moveto (Link Area ->) show

% Annotations
[ /Subtype /Link /Rect [50 715 200 735] /Action << /S /URI /URI (https://www.eifelcode.com) >> /ANN pdfmark
[ /Subtype /Square /Rect [250 710 300 750] /Color [1 0 0] /ANN pdfmark
[ /Subtype /Circle /Rect [320 710 370 750] /Color [0 0 1] /ANN pdfmark
[ /Subtype /Line /Rect [250 650 350 670] /L [250 650 350 670] /Color [0 0 0] /ANN pdfmark

showpage


% PAGE 3: Drawings & Stamps (With Visual Markers)
% -----------------------------------------------------------------------------
/${font_name} findfont 11 scalefont setfont

50 780 moveto (pdfmt Test Fixture - Page 3: Drawings & Stamps (With Visual Markers)) show

% 1. Visible Marker for Ink Box [50 700 130 730]
newpath 50 700 moveto 130 700 lineto 130 730 lineto 50 730 lineto closepath stroke
50 735 moveto (Ink Zone Marker) show

% 2. Visible Marker for Stamp Box [250 700 350 740]
newpath 250 700 moveto 350 700 lineto 350 740 lineto 250 740 lineto closepath stroke
250 745 moveto (Stamp Zone Marker) show

% Annotations
[ /Subtype /Ink /Rect [50 700 130 730] /InkList [ [50 700 90 730 130 700] ] /Color [1 0 1] /ANN pdfmark
[ /Subtype /Stamp /Rect [250 700 350 740] /Name /Approved /ANN pdfmark

showpage
EOF
}

main "$@"
