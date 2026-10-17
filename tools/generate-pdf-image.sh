#!/usr/bin/env bash
# =====================================================================================================================
# Script: generate-pdf-image.sh
#
# Description:
# Generates an A4 PDF embedding a PNG image centered. Keeps natural size if it fits, or scales it down proportionally
# to fit within A4 bounds using ImageMagick, with a white background.
#
# Usage:
# ./generate-pdf-image.sh <image.png> <output.pdf>
#
# Example:
# ./generate-pdf-image.sh image.png output.pdf
# =====================================================================================================================
set -euo pipefail

function main()
{
    if (( $# < 2 )); then
        echo "Usage:   $0 <image.png> <output.pdf>" >&2
        echo "Example: $0 tests/_data/sample.png output.pdf" >&2
        return 1
    fi


    # Load
    # -----------------------------------------------------------------------------------------------------------------
    local -r input_file="${1}"
    local -r output_file="${2}"


    # Verify
    # -----------------------------------------------------------------------------------------------------------------
    if [[ ! -f "${input_file}" ]]; then
        echo "ERROR: Image file not found at ${input_file}" >&2
        return 1
    fi


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    if command -v magick &> /dev/null; then
        magick "${input_file}" \
            -resize '595x842>' \
            -gravity center \
            -background white \
            -alpha remove \
            -alpha off \
            -extent 595x842 \
            -strip \
            PNG:- \
        | magick PNG:- "${output_file}"
    elif command -v convert &> /dev/null; then
        convert "${input_file}" \
            -resize '595x842>' \
            -gravity center \
            -background white \
            -alpha remove \
            -alpha off \
            -extent 595x842 \
            -strip \
            PNG:- \
        | convert PNG:- "${output_file}"
    else
        echo "ERROR: Neither ImageMagick (magick/convert) nor a compatible tool is installed." >&2
        return 1
    fi
}

main "$@"
