#!/usr/bin/env bash
# =====================================================================================================================
# Script: generate-png-text.sh
#
# Description:
# Generates a PNG image containing a given text rendered with a specified TrueType font (.ttf) using ImageMagick.
#
# Usage:
# ./generate-png-text.sh <font.ttf> <output.png> <text>
#
# Example:
# ./generate-png-text.sh DejaVuSans-Bold.ttf output.png "hello world!"
# =====================================================================================================================
set -euo pipefail

function main()
{
    if (( $# < 3 )); then
        echo "Usage:   $0 <font.ttf> <output.png> <text>" >&2
        echo "Example: $0 tests/_data/DejaVuSans-Bold.ttf output.png \"hallo welt!\"" >&2
        return 1
    fi

    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r font_file="${1}"
    local -r output_file="${2}"
    local -r text_content="${3}"


    # Verify
    # -----------------------------------------------------------------------------------------------------------------
    if [[ ! -f "${font_file}" ]]; then
        echo "ERROR: Font file not found at ${font_file}" >&2
        return 1
    fi


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    # Use ImageMagick with explicit font, font size, background and text color
    if command -v magick &> /dev/null; then
        magick -font "${font_file}" -pointsize 32 -background white -fill black label:"${text_content}" "${output_file}"
    elif command -v convert &> /dev/null; then
        convert -font "${font_file}" -pointsize 32 -background white -fill black label:"${text_content}" "${output_file}"
    else
        echo "ERROR: Neither ImageMagick (magick/convert) nor a compatible tool is installed." >&2
        return 1
    fi
}

main "$@"
