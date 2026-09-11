#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/pdf.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    :
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_get_num_pages()
{
    local exit_code=0
    local result

    result=$(_pdf_get_num_pages "${ROOT_DIR}/tests/_data/pages.pdf") || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "8" "${result}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_get_num_pages_file_not_found()
{
    local exit_code=0

    _pdf_get_num_pages "${ROOT_DIR}/tests/_data/unknown-file.pdf" >/dev/null 2>&1 || exit_code=$?

    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_single_page()
{
    local exit_code=0
    local result

    result=$(_pdf_parse_ranges "5") || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "5" "${result}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_page_range()
{
    local exit_code=0
    local result

    result=$(_pdf_parse_ranges "1-3") || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "1 2 3" "${result}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_multiple_pages()
{
    local exit_code=0
    local result

    result=$(_pdf_parse_ranges "1,3,5") || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "1 3 5" "${result}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_multiple_ranges()
{
    local exit_code=0
    local result

    result=$(_pdf_parse_ranges "1-3,5-7") || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "1 2 3 5 6 7" "${result}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_mixed_pages_and_ranges()
{
    local exit_code=0
    local result

    result=$(_pdf_parse_ranges "1-3,5,8-10") || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "1 2 3 5 8 9 10" "${result}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_max_pages()
{
    local exit_code=0
    local result

    result=$(_pdf_parse_ranges "3-5" "5") || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "3 4 5" "${result}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_page_exceeds_max_pages()
{
    local exit_code=0

    _pdf_parse_ranges "6" "5" >/dev/null 2>&1 || exit_code=$?

    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_range_exceeds_max_pages()
{
    local exit_code=0

    _pdf_parse_ranges "3-6" "5" >/dev/null 2>&1 || exit_code=$?

    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_invalid_range_order()
{
    local exit_code=0

    _pdf_parse_ranges "3-1" >/dev/null 2>&1 || exit_code=$?

    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_invalid_range()
{
    local exit_code=0

    _pdf_parse_ranges "invalid" >/dev/null 2>&1 || exit_code=$?

    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_zero_page()
{
    local exit_code=0

    _pdf_parse_ranges "0" >/dev/null 2>&1 || exit_code=$?

    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_pdf_parse_ranges_with_spaces()
{
    local exit_code=0
    local result

    result=$(_pdf_parse_ranges "1-3, 5, 8-10") || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_same "1 2 3 5 8 9 10" "${result}"
}
