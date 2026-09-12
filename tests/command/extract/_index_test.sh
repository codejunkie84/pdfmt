#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/extract/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/extract/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/extract/even.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/extract/odd.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/extract/range.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_extract()
{
    local exit_code=0
    local output

    output=$(command_extract "") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt extract <command>" "${output}"

    output=$(command_extract help) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt extract <command>" "${output}"

    output=$(command_extract even) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt extract even" "${output}"

    output=$(command_extract odd) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt extract odd" "${output}"

    output=$(command_extract range) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt extract range" "${output}"

    output=$(command_extract foobar 2>&1) || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "ERROR: Unknown command 'foobar'" "${output}"
}
