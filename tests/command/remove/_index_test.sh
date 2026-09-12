#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/remove/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/remove/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/remove/even.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/remove/odd.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/remove/range.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove()
{
    local exit_code=0
    local output

    output=$(command_remove "") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt remove <command>" "${output}"

    output=$(command_remove help) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt remove <command>" "${output}"

    output=$(command_remove even) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt remove even" "${output}"

    output=$(command_remove odd) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt remove odd" "${output}"

    output=$(command_remove range) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt remove range" "${output}"

    output=$(command_remove foobar 2>&1) || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "ERROR: Unknown command 'foobar'" "${output}"
}
