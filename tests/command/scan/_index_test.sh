#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/scan/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/scan/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/scan/adf.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/scan/flatbed.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_scan()
{
    local exit_code=0
    local output

    output=$(command_scan "") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt scan <command>" "${output}"

    output=$(command_scan help) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt scan <command>" "${output}"

    output=$(command_scan adf) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt scan adf" "${output}"

    output=$(command_scan flatbed) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt scan flatbed" "${output}"

    output=$(command_scan foobar 2>&1) || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "ERROR: Unknown command 'foobar'" "${output}"
}
