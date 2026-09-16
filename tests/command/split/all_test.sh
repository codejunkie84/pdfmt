#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/split/all.sh"

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
function test_command_split_all()
{
    local exit_code=0

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_split_all "${ROOT_DIR}/tests/_data/pages.pdf" || exit_code=$?

    assert_same \
        "pages_1.pdf pages_2.pdf pages_3.pdf pages_4.pdf pages_5.pdf pages_6.pdf pages_7.pdf pages_8.pdf" \
        "$(printf '%s\n' * | tr '\n' ' ' | sed 's/ $//')"

    assert_same "0" "${exit_code}"
    assert_same "1" "$(pdftotext pages_1.pdf - | tr -d '[:space:]')"
    assert_same "2" "$(pdftotext pages_2.pdf - | tr -d '[:space:]')"
    assert_same "3" "$(pdftotext pages_3.pdf - | tr -d '[:space:]')"
    assert_same "4" "$(pdftotext pages_4.pdf - | tr -d '[:space:]')"
    assert_same "5" "$(pdftotext pages_5.pdf - | tr -d '[:space:]')"
    assert_same "6" "$(pdftotext pages_6.pdf - | tr -d '[:space:]')"
    assert_same "7" "$(pdftotext pages_7.pdf - | tr -d '[:space:]')"
    assert_same "8" "$(pdftotext pages_8.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_split_all_with_output_prefix()
{
    local exit_code=0

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_split_all "${ROOT_DIR}/tests/_data/pages.pdf" "foobar" || exit_code=$?

    assert_same \
        "foobar1.pdf foobar2.pdf foobar3.pdf foobar4.pdf foobar5.pdf foobar6.pdf foobar7.pdf foobar8.pdf" \
        "$(printf '%s\n' * | tr '\n' ' ' | sed 's/ $//')"

    assert_same "0" "${exit_code}"
    assert_same "1" "$(pdftotext foobar1.pdf - | tr -d '[:space:]')"
    assert_same "2" "$(pdftotext foobar2.pdf - | tr -d '[:space:]')"
    assert_same "3" "$(pdftotext foobar3.pdf - | tr -d '[:space:]')"
    assert_same "4" "$(pdftotext foobar4.pdf - | tr -d '[:space:]')"
    assert_same "5" "$(pdftotext foobar5.pdf - | tr -d '[:space:]')"
    assert_same "6" "$(pdftotext foobar6.pdf - | tr -d '[:space:]')"
    assert_same "7" "$(pdftotext foobar7.pdf - | tr -d '[:space:]')"
    assert_same "8" "$(pdftotext foobar8.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_split_all_output_already_exists()
{
    local exit_code=0

    echo "foobar" > pages_6.pdf

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_split_all "${ROOT_DIR}/tests/_data/pages.pdf" || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_same "pages_6.pdf" "$(printf '%s\n' * | tr '\n' ' ' | sed 's/ $//')"
    assert_same "foobar" "$(cat pages_6.pdf)"
}
