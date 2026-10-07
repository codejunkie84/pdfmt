#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/ocr/show.sh"

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
function test_command_ocr_show()
{
    local exit_code=0
    local output

    output="$(command_ocr_show "${ROOT_DIR}/tests/_data/pages.pdf")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "12345678" "$(echo "${output}" | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_ocr_show_input_file_not_existing()
{
    local exit_code=0
    local output

    output="$(command_ocr_show "${ROOT_DIR}/tests/_data/unknown-file.pdf")" || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "" "$(echo "${output}" | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_ocr_show_no_ocr()
{
    local exit_code=0
    local output

    output="$(command_ocr_show "${ROOT_DIR}/tests/_data/no-ocr.pdf")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "" "$(echo "${output}" | tr -d '[:space:]')"
}
