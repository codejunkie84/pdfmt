#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/platform.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    [[ -n "${tmp_file:-}" ]] && rm -f -- "${tmp_file}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_create_temp_file()
{
    local exit_code=0

    tmp_file="$(_create_temp_file)" || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_file_exists "${tmp_file}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_create_temp_file_with_suffix()
{
    local exit_code=0

    tmp_file="$(_create_temp_file ".pdf")" || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_file_exists "${tmp_file}"
    assert_same ".pdf" "${tmp_file: -4}"
}