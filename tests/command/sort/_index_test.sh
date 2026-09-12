#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/sort/_index.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/sort/help.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/sort/duplex.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/sort/move.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/sort/random.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/sort/reverse.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/sort/swap.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_sort()
{
    local exit_code=0
    local output

    output=$(command_sort "") || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt sort <command>" "${output}"

    output=$(command_sort help) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt sort <command>" "${output}"

    output=$(command_sort duplex) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt sort duplex" "${output}"

    output=$(command_sort move) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt sort move" "${output}"

    output=$(command_sort random) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt sort random" "${output}"

    output=$(command_sort reverse) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt sort reverse" "${output}"

    output=$(command_sort swap) || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "pdfmt sort swap" "${output}"

    output=$(command_sort foobar 2>&1) || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "ERROR: Unknown command 'foobar'" "${output}"
}
