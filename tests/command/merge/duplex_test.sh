#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/merge/duplex.sh"

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
function test_command_merge_duplex()
{
    local exit_code=0

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_merge_duplex \
        "${ROOT_DIR}/tests/_data/duplex-frontside.pdf" \
        "${ROOT_DIR}/tests/_data/duplex-backside.pdf" \
        output.pdf || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "output.pdf" "$(printf '%s\n' *)"
    assert_same "12345678" "$(pdftotext output.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_merge_duplex_with_not_existing_file()
{
    local exit_code=0

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_merge_duplex \
        "${ROOT_DIR}/tests/_data/duplex-frontside.pdf" \
        "${ROOT_DIR}/tests/_data/unknown-file.pdf" \
        output.pdf || exit_code=$?

    assert_same "1" "${exit_code}"

    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_merge_duplex_output_already_exists()
{
    local exit_code=0

    echo "foobar" > output.pdf

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    command_merge_duplex \
        "${ROOT_DIR}/tests/_data/duplex-frontside.pdf" \
        "${ROOT_DIR}/tests/_data/duplex-backside.pdf" \
        output.pdf || exit_code=$?

    assert_same "1" "${exit_code}"
    assert_same "output.pdf" "$(printf '%s\n' *)"
    assert_same "foobar" "$(cat output.pdf)"
}
