#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/split/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/split/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/split/all.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/split/length.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/split/range.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_split()
{
    local exit_code=0
    local output

    output=$(command_split "") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt split <command>" "${output}"

    output=$(command_split help) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt split <command>" "${output}"

    output=$(command_split all) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt split all" "${output}"

    output=$(command_split length) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt split length" "${output}"

    output=$(command_split range) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt split range" "${output}"

    output=$(command_split foobar 2>&1) || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "ERROR: Unknown command 'foobar'" "${output}"
}
