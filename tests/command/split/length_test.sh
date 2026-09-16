#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/split/length.sh"

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
function test_command_split_length()
{
    local exit_code=0

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_split_length "${ROOT_DIR}/tests/_data/pages.pdf" 2 || exit_code=$?

    assert_same \
        "pages_1.pdf pages_2.pdf pages_3.pdf pages_4.pdf" \
        "$(printf '%s\n' * | tr '\n' ' ' | sed 's/ $//')"

    assert_same "0" "${exit_code}"
    assert_same "12" "$(pdftotext pages_1.pdf - | tr -d '[:space:]')"
    assert_same "34" "$(pdftotext pages_2.pdf - | tr -d '[:space:]')"
    assert_same "56" "$(pdftotext pages_3.pdf - | tr -d '[:space:]')"
    assert_same "78" "$(pdftotext pages_4.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_split_length_with_output_prefix()
{
    local exit_code=0

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_split_length "${ROOT_DIR}/tests/_data/pages.pdf" 2 foobar || exit_code=$?

    assert_same \
        "foobar1.pdf foobar2.pdf foobar3.pdf foobar4.pdf" \
        "$(printf '%s\n' * | tr '\n' ' ' | sed 's/ $//')"

    assert_same "0" "${exit_code}"
    assert_same "12" "$(pdftotext foobar1.pdf - | tr -d '[:space:]')"
    assert_same "34" "$(pdftotext foobar2.pdf - | tr -d '[:space:]')"
    assert_same "56" "$(pdftotext foobar3.pdf - | tr -d '[:space:]')"
    assert_same "78" "$(pdftotext foobar4.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_split_length_output_already_exists()
{
    local exit_code=0

    echo "foobar" > pages_3.pdf

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_split_length "${ROOT_DIR}/tests/_data/pages.pdf" 2 || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_same "pages_3.pdf" "$(printf '%s\n' * | tr '\n' ' ' | sed 's/ $//')"
    assert_same "foobar" "$(cat pages_3.pdf)"
}
