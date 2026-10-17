#!/usr/bin/env bash
# =====================================================================================================================
# Script: generate-test-data.sh
#
# Description:
# Generates all required test data for the unit tests.
#
# Usage:
# ./generate-test-data.sh <font.ttf> <output-directory>
#
# Example:
# ./generate-test-data.sh tests/_data/
# =====================================================================================================================
set -euo pipefail

function main()
{
    if (( $# < 2 )); then
        echo "Usage:   $0 <font.ttf> <output-directory>" >&2
        echo "Example: $0 DejaVuSans-Bold.ttf tests/_data/" >&2
        return 1
    fi

    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r base="$(dirname "$0")"
    local -r font_file="${1}"
    local -r directory="${2}"


    # Verify
    # -----------------------------------------------------------------------------------------------------------------
    if [[ ! -f "${font_file}" ]]; then
        echo "ERROR: Font file not found at ${font_file}" >&2
        return 1
    fi


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    mkdir -p "$directory"

    # file: scan.png
    "$base/generate-png-text.sh" "$font_file" "$directory/scan.png" "scan"

    # file: no-ocr.pdf
    "$base/generate-png-text.sh" "$font_file" "$directory/image.png" "PDF with no OCR"
    "$base/generate-pdf-image.sh" "$directory/image.png" "$directory/no-ocr.pdf"
    rm "$directory/image.png"

    # file: pages.pdf
    "$base/generate-pdf-pages.sh" "$font_file" "$directory/pages.pdf"            1 2 3 4 5 6 7 8

    # file: duplex.pdf, duplex-frontside.pdf, duplex-backside.pdf
    "$base/generate-pdf-pages.sh" "$font_file" "$directory/duplex.pdf"           1 3 5 7 8 6 4 2
    "$base/generate-pdf-pages.sh" "$font_file" "$directory/duplex-frontside.pdf" 1 3 5 7
    "$base/generate-pdf-pages.sh" "$font_file" "$directory/duplex-backside.pdf"  8 6 4 2

    # file: annotations.pdf
    "$base/generate-pdf-annotation.sh" "$font_file" "$directory/annotations.pdf"
}

main "$@"
