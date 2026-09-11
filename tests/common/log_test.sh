#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/log.sh"

    export TEST_DIR="/tmp/bashunit_test_$$"
    mkdir -p "$TEST_DIR"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "$TEST_DIR"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_log_info()
{
    local exit_code=0

    _log_info "file created" >"${TEST_DIR}/stdout" 2>"${TEST_DIR}/stderr" || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "INFO: file created" "$(cat "${TEST_DIR}/stdout")"
    assert_same "" "$(cat "${TEST_DIR}/stderr")"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_log_warning()
{
    local exit_code=0

    _log_warning "file not found" >"${TEST_DIR}/stdout" 2>"${TEST_DIR}/stderr" || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "" "$(cat "${TEST_DIR}/stdout")"
    assert_same "WARNING: file not found" "$(cat "${TEST_DIR}/stderr")"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_log_error()
{
    local exit_code=0

    _log_error "file not found" >"${TEST_DIR}/stdout" 2>"${TEST_DIR}/stderr" || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "" "$(cat "${TEST_DIR}/stdout")"
    assert_same "ERROR: file not found" "$(cat "${TEST_DIR}/stderr")"
}
