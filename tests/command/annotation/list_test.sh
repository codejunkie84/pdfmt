#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/annotation/list.sh"

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
function test_command_annotation_list_help()
{
    local exit_code=0
    local output

    output="$(command_annotation_list)" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_matches "List all annotation types present in a PDF document" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_list_with_annotations()
{
    local exit_code=0
    local output

    output="$(command_annotation_list "${ROOT_DIR}/tests/_data/annotations.pdf")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_matches "Annotations found in" "${output}"
    assert_matches "Highlight" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_list_without_annotations()
{
    local exit_code=0
    local output

    output="$(command_annotation_list "${ROOT_DIR}/tests/_data/pages.pdf")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_matches "No annotations found in" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_annotation_list_input_file_not_existing()
{
    local exit_code=0
    local output

    output="$(command_annotation_list "${ROOT_DIR}/tests/_data/unknown-file.pdf")" || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "" "$(echo "${output}" | tr -d '[:space:]')"
}
