#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/split/range.sh"

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
function test_command_split_range()
{
    local exit_code=0

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_split_range "${ROOT_DIR}/tests/_data/pages.pdf" 1-4,6,7-8 1-3,5 || exit_code=$?

    assert_same \
        "pages_1.pdf pages_2.pdf" \
        "$(printf '%s\n' * | tr '\n' ' ' | sed 's/ $//')"

    assert_same "0" "${exit_code}"
    assert_same "1234678" "$(pdftotext pages_1.pdf - | tr -d '[:space:]')"
    assert_same "1235" "$(pdftotext pages_2.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_split_range_with_output_prefix()
{
    local exit_code=0

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_split_range "${ROOT_DIR}/tests/_data/pages.pdf" 1-4,6,7-8 1-3,5 foobar || exit_code=$?

    assert_same \
        "foobar1.pdf foobar2.pdf" \
        "$(printf '%s\n' * | tr '\n' ' ' | sed 's/ $//')"

    assert_same "0" "${exit_code}"
    assert_same "1234678" "$(pdftotext foobar1.pdf - | tr -d '[:space:]')"
    assert_same "1235" "$(pdftotext foobar2.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_split_range_output_already_exists()
{
    local exit_code=0

    echo "foobar" > pages_2.pdf

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_split_range "${ROOT_DIR}/tests/_data/pages.pdf" 1-4,6,7-8 1-3,5 || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_same "pages_2.pdf" "$(printf '%s\n' * | tr '\n' ' ' | sed 's/ $//')"
    assert_same "foobar" "$(cat pages_2.pdf)"
}
