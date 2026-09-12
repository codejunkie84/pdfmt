#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/merge/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/merge/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/merge/all.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/merge/duplex.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/merge/insert.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_merge()
{
    local exit_code=0
    local output

    output=$(command_merge "") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt merge <command>" "${output}"

    output=$(command_merge help) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt merge <command>" "${output}"

    output=$(command_merge all) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt merge all" "${output}"

    output=$(command_merge duplex) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt merge duplex" "${output}"

    output=$(command_merge insert) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt merge insert" "${output}"

    output=$(command_merge foobar 2>&1) || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "ERROR: Unknown command 'foobar'" "${output}"
}
