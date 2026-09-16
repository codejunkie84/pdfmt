#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/extract/range.sh"

    export TEST_DIR="/tmp/bashunit_test_$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR" || exit 1
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "$TEST_DIR"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_extract_range()
{
    local exit_code=0

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_extract_range "${ROOT_DIR}/tests/_data/pages.pdf" 1-3,4,7-8 output.pdf || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "output.pdf" "$(printf '%s\n' *)"
    assert_same "123478" "$(pdftotext output.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_extract_range_output_already_exists()
{
    local exit_code=0

    echo "foobar" > output.pdf

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_extract_range "${ROOT_DIR}/tests/_data/pages.pdf" 1-3,4,7-8 output.pdf || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_same "output.pdf" "$(printf '%s\n' *)"
    assert_same "foobar" "$(cat output.pdf)"
}
