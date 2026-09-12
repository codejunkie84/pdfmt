#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/stamp/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/stamp/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/stamp/text.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_stamp()
{
    local exit_code=0
    local output

    output=$(command_stamp "") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt stamp <command>" "${output}"

    output=$(command_stamp help) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt stamp <command>" "${output}"

    output=$(command_stamp text) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt stamp text" "${output}"

    output=$(command_stamp foobar 2>&1) || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "ERROR: Unknown command 'foobar'" "${output}"
}
