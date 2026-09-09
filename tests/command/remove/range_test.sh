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
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 1-2,4,7-8 output.pdf

    assert_same "output.pdf" "$(printf '%s\n' *)"

    assert_same "356" "$(pdftotext output.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_first()
{
    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 1 output.pdf

    assert_same "output.pdf" "$(printf '%s\n' *)"

    assert_same "2345678" "$(pdftotext output.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_last()
{
    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 8 output.pdf

    assert_same "output.pdf" "$(printf '%s\n' *)"

    assert_same "1234567" "$(pdftotext output.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_0()
{
    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 0 output.pdf

    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_negative()
{
    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" -1 output.pdf

    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_start_higher_than_end()
{
    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 5-2 output.pdf

    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_all_pages()
{
    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 1-8 output.pdf

    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_page_as_range()
{
    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 5-5 output.pdf

    assert_same "output.pdf" "$(printf '%s\n' *)"

    assert_same "1234678" "$(pdftotext output.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_not_existing_pages()
{
    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 10-20 output.pdf

    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_remove_range_partial_existing_pages()
{
    # shellcheck disable=SC1091 # ROOT_DIR is provided by the bootstrap.
    command_remove_range "${ROOT_DIR}/tests/_data/pages.pdf" 5-20 output.pdf

    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}
