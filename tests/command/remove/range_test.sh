#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/remove/range.sh"

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
function test_command_remove_range()
{
    local exit_code=0

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 1-2,4,7-8 output.pdf || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "output.pdf" "$(printf '%s\n' *)"
    assert_same "356" "$(pdftotext output.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_first()
{
    local exit_code=0

    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 1 output.pdf || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "output.pdf" "$(printf '%s\n' *)"
    assert_same "2345678" "$(pdftotext output.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_last()
{
    local exit_code=0

    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 8 output.pdf || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "output.pdf" "$(printf '%s\n' *)"
    assert_same "1234567" "$(pdftotext output.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_0()
{
    local exit_code=0

    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 0 output.pdf || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_negative()
{
    local exit_code=0

    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" -1 output.pdf || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_start_higher_than_end()
{
    local exit_code=0

    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 5-2 output.pdf || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_all_pages()
{
    local exit_code=0

    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 1-8 output.pdf || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_as_range()
{
    local exit_code=0

    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 5-5 output.pdf || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "output.pdf" "$(printf '%s\n' *)"
    assert_same "1234678" "$(pdftotext output.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_not_existing_pages()
{
    local exit_code=0

    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 10-20 output.pdf || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_partial_existing_pages()
{
    local exit_code=0

    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 5-20 output.pdf || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_output_already_exists()
{
    local exit_code=0

    echo "foobar" > output.pdf

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 1-2,4,7-8 output.pdf || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_same "output.pdf" "$(printf '%s\n' *)"
    assert_same "foobar" "$(cat output.pdf)"
}
