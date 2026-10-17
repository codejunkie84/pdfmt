#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/annotation/remove.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/annotation/show.sh"

    export TEST_DIR="/tmp/bashunit_test_$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR" || exit 1
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "$TEST_DIR"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_remove_help()
{
    local exit_code=0
    local output

    output="$(command_annotation_remove)" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_matches "Remove annotations from a PDF document" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_remove_all()
{
    local exit_code=0
    local output
    local output_file="cleaned.pdf"

    # pre check
    output="$(command_annotation_show "${ROOT_DIR}/tests/_data/annotations.pdf" "all")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "Page 1" "${output}"

    # function check
    command_annotation_remove "${ROOT_DIR}/tests/_data/annotations.pdf" "all" "${output_file}" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "${output_file}" "$(printf '%s\n' *)"

    # post check
    output="$(command_annotation_show "${output_file}" "all")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_not_contains "Page 1" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_remove_specific_type()
{
    local exit_code=0
    local output_file="cleaned_circle.pdf"

    # pre check
    output="$(command_annotation_show "${ROOT_DIR}/tests/_data/annotations.pdf" "all")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "Page 1: Highlight" "${output}"
    assert_contains "Page 1: Underline" "${output}"
    assert_contains "Page 1: StrikeOut" "${output}"
    assert_contains "Page 1: Squiggly" "${output}"

    # function check
    command_annotation_remove "${ROOT_DIR}/tests/_data/annotations.pdf" "underline,strikeout" "${output_file}" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "${output_file}" "$(printf '%s\n' *)"

    # post check
    output="$(command_annotation_show "${output_file}" "all")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "Page 1: Highlight" "${output}"
    assert_not_contains "Page 1: Underline" "${output}"
    assert_not_contains "Page 1: StrikeOut" "${output}"
    assert_contains "Page 1: Squiggly" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_remove_unknown_type()
{
    local exit_code=0
    local output_file="failed.pdf"

    command_annotation_remove "${ROOT_DIR}/tests/_data/annotations.pdf" "nonexistenttype" "${output_file}" || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_not_same "${output_file}" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_remove_input_file_not_existing()
{
    local exit_code=0
    local output_file="output.pdf"

    command_annotation_remove "${ROOT_DIR}/tests/_data/unknown-file.pdf" "all" "${output_file}" || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_not_same "${output_file}" "$(printf '%s\n' *)"
}
