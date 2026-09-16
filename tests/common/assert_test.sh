#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
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
function test_common_assert_is_installed()
{
    local exit_code=0

    _assert_is_installed cat || exit_code=$?
    assert_same "0" "${exit_code}"

    _assert_is_installed foobarbazbubu || exit_code=$?
    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_common_assert_is_file()
{
    local exit_code=0

    _assert_is_file "${ROOT_DIR}/tests/_data/pages.pdf" || exit_code=$?
    assert_same "0" "${exit_code}"

    _assert_is_file "${ROOT_DIR}/tests/_data/unknown-file" || exit_code=$?
    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_common_assert_is_not_file()
{
    local exit_code=0

    _assert_is_not_file "${ROOT_DIR}/tests/_data/unknown-file" || exit_code=$?
    assert_same "0" "${exit_code}"

    _assert_is_not_file "${ROOT_DIR}/tests/_data/pages.pdf" || exit_code=$?
    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_common_assert_is_not_empty()
{
    local exit_code=0

    _assert_is_not_empty "foobar" || exit_code=$?
    assert_same "0" "${exit_code}"

    _assert_is_not_empty "" || exit_code=$?
    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_common_assert_is_digit()
{
    local exit_code=0

    _assert_is_digit "123456789" || exit_code=$?
    assert_same "0" "${exit_code}"

    _assert_is_digit "123abc" || exit_code=$?
    assert_same "1" "${exit_code}"
}
