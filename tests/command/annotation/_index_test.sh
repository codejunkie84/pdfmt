#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/annotation/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/annotation/help.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation()
{
    local exit_code=0
    local output

    output=$(command_annotation "") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt annotation <command>" "${output}"

    output=$(command_annotation help) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt annotation <command>" "${output}"

    output=$(command_annotation foobar 2>&1) || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "ERROR: Unknown command 'foobar'" "${output}"
}
