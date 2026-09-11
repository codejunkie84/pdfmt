#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/cleanup.sh"

    export TEST_DIR="/tmp/bashunit_test_$$"
    mkdir -p "$TEST_DIR"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "$TEST_DIR"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_cleanup_without_files()
{
    FILES_TO_CLEANUP=()

    _cleanup

    assert_same "0" "$?"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_cleanup_removes_files()
{
    local file1="${TEST_DIR}/file1"
    local file2="${TEST_DIR}/file2"

    touch "${file1}" "${file2}"
    FILES_TO_CLEANUP=("${file1}" "${file2}")

    _cleanup

    assert_file_not_exists "${file1}"
    assert_file_not_exists "${file2}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_cleanup_removes_directories()
{
    local directory="${TEST_DIR}/directory"

    mkdir -p "${directory}"
    touch "${directory}/file"

    # shellcheck disable=SC2034     # FILES_TO_CLEANUP is consumed by _cleanup.
    FILES_TO_CLEANUP=("${directory}")

    _cleanup

    assert_file_not_exists "${directory}"
}
