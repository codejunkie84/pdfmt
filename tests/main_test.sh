#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/main.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/version.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/extract/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/extract/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/merge/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/merge/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/remove/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/remove/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/scan/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/scan/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/sort/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/sort/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/split/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/split/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/stamp/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/stamp/help.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_main()
{
    local exit_code=0
    local output

    # shellcheck disable=SC2034         # will be used in main
    VERSION=0.0.0

    output=$(main "") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt <command>" "${output}"

    output=$(main help) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt <command> <subcommand> [arguments]" "${output}"

    output=$(main version) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "$VERSION" "${output}"

     output=$(main extract) || exit_code=$?
     assert_same "0" "${exit_code}"
     assert_contains "pdfmt extract <command> [arguments]" "${output}"

     output=$(main merge) || exit_code=$?
     assert_same "0" "${exit_code}"
     assert_contains "pdfmt merge <command> [arguments]" "${output}"

     output=$(main remove) || exit_code=$?
     assert_same "0" "${exit_code}"
     assert_contains "pdfmt remove <command> [arguments]" "${output}"

     output=$(main scan) || exit_code=$?
     assert_same "0" "${exit_code}"
     assert_contains "pdfmt scan <command> [arguments]" "${output}"

     output=$(main sort) || exit_code=$?
     assert_same "0" "${exit_code}"
     assert_contains "pdfmt sort <command> [arguments]" "${output}"

     output=$(main split) || exit_code=$?
     assert_same "0" "${exit_code}"
     assert_contains "pdfmt split <command> [arguments]" "${output}"

     output=$(main stamp) || exit_code=$?
     assert_same "0" "${exit_code}"
     assert_contains "pdfmt stamp <command> [arguments]" "${output}"

    output=$(main foobar 2>&1) || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "ERROR: Unknown command 'foobar'" "${output}"
}
