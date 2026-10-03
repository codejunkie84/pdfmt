#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/workflow/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/workflow/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/workflow/info.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/workflow/list.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/workflow/run.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow()
{
    local exit_code=0
    local output

    output=$(command_workflow "") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt workflow <command>" "${output}"

    output=$(command_workflow help) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt workflow <command>" "${output}"

    output=$(command_workflow info) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt workflow info" "${output}"

    output=$(command_workflow list) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "" "${output}"

    output=$(command_workflow run) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt workflow run" "${output}"

    output=$(command_workflow foobar 2>&1) || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "ERROR: Unknown command 'foobar'" "${output}"
}
