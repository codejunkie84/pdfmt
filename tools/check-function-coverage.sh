#!/usr/bin/env bash
# =====================================================================================================================
# Check function test coverage
#
# Reports which functions defined in the sources directory are directly
# referenced by shell tests in the tests directory.
#
# A function is considered tested when its name is referenced in at least one
# test file. This does not measure runtime, line, branch, or assertion coverage.
#
# Usage:
#   tools/check-function-coverage.sh [SOURCE_DIR] [TEST_DIR]
#
# Defaults:
#   SOURCE_DIR=sources
#   TEST_DIR=tests
# =====================================================================================================================

set -euo pipefail

SOURCE_DIR="${1:-sources}"
TEST_DIR="${2:-tests}"

function extract_functions()
{
    local -r file="$1"

    sed -nE \
        's/^[[:space:]]*function[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*).*/\1/p' \
        "$file"
}

function find_test_files()
{
    local -r function_name="$1"

    grep -RIl \
        --include='*.sh' \
        --word-regexp \
        -- "$function_name" "$TEST_DIR" 2>/dev/null |
        sort || true
}

function main()
{
    local total=0
    local tested=0
    local untested=0
    local source_file
    local functions
    local function_name
    local test_files
    local test_file

    if [[ ! -d "$SOURCE_DIR" ]]; then
        echo "Error: source directory not found: $SOURCE_DIR" >&2
        exit 2
    fi

    if [[ ! -d "$TEST_DIR" ]]; then
        echo "Error: test directory not found: $TEST_DIR" >&2
        exit 2
    fi

    echo "Function test coverage"
    echo "======================"
    echo
    printf '%-10s %-45s %-30s %s\n' \
        "STATUS" \
        "SOURCE" \
        "FUNCTION" \
        "TEST"
    echo
    while IFS= read -r -d '' source_file; do
        functions="$(extract_functions "$source_file")"

        [[ -z "$functions" ]] && continue

        while IFS= read -r function_name; do
            [[ -z "$function_name" ]] && continue

            total=$((total + 1))

            test_files="$(find_test_files "$function_name")"

            if [[ -n "$test_files" ]]; then
                tested=$((tested + 1))

                while IFS= read -r test_file; do
                    [[ -z "$test_file" ]] && continue

                    printf 'Okay       %-45s %-30s %s\n' \
                        "$source_file" \
                        "$function_name" \
                        "$test_file"
                done <<< "$test_files"
            else
                untested=$((untested + 1))

                printf 'Missing   %s %-45s %-30s\n' \
                    "" \
                    "$source_file" \
                    "$function_name"
            fi
        done <<< "$functions"

    done < <(
        find "$SOURCE_DIR" \
            -type f \
            -name '*.sh' \
            -print0 |
        sort -z
    )

    echo
    echo "Summary"
    echo "======="
    printf 'Okay    %d/%d tested (%d%%)\n' \
        "$tested" \
        "$total" \
        "$((total > 0 ? tested * 100 / total : 0))"

    if (( untested > 0 )); then
        printf 'Missing %d untested\n' "$untested"
        exit 1
    fi

    exit 0
}

main "$@"
