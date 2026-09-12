#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/version.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_version_unknown()
{
    local exit_code=0
    local output

    output=$(command_version) || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_version()
{
    local exit_code=0
    local output

    # shellcheck disable=SC2034         # will be used in command_version
    VERSION=0.0.0
    output=$(command_version) || exit_code=$?
    unset VERSION

    assert_same "0" "${exit_code}"
    assert_contains "0.0.0" "${output}"
}
