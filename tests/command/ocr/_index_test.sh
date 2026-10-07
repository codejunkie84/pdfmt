#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/ocr/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/ocr/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/ocr/add.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/ocr/exists.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/ocr/show.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_ocr()
{
    local exit_code=0
    local output

    output=$(command_ocr "") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt ocr <command>" "${output}"

    output=$(command_ocr help) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt ocr <command>" "${output}"

    output=$(command_ocr add) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt ocr add" "${output}"

    output=$(command_ocr exists) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt ocr exists" "${output}"

    output=$(command_ocr show) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt ocr show" "${output}"

    output=$(command_ocr foobar 2>&1) || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "ERROR: Unknown command 'foobar'" "${output}"
}
