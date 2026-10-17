#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
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
function test_command_annotation_show_help()
{
    local exit_code=0
    local output

    output="$(command_annotation_show)" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_matches "Show annotation details into plain text format" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_show_all_to_stdout()
{
    local exit_code=0
    local output

    output="$(command_annotation_show "${ROOT_DIR}/tests/_data/annotations.pdf" "all")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_matches "Page 1" "${output}"
    assert_matches "Page 2" "${output}"
    assert_matches "Page 3" "${output}"
    assert_matches "Highlight" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_show_specific_type()
{
    local exit_code=0
    local output

    output="$(command_annotation_show "${ROOT_DIR}/tests/_data/annotations.pdf" "text,link")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_matches "Link" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_show_unknown_type()
{
    local exit_code=0
    local output

    output="$(command_annotation_show "${ROOT_DIR}/tests/_data/annotations.pdf" "nonexistenttype")" || exit_code=$?
    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_show_input_file_not_existing()
{
    local exit_code=0
    local output

    output="$(command_annotation_show "${ROOT_DIR}/tests/_data/unknown-file.pdf" "all")" || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "" "$(echo "${output}" | tr -d '[:space:]')"
}
