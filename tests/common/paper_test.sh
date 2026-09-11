#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/paper.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_paper_get_format_sizes()
{
    local format
    local width
    local height

    declare -A expected_width=(
        [A0]=841
        [A1]=594
        [A2]=420
        [A3]=297
        [A4]=210
        [A5]=148
        [A6]=105
        [B0]=1000
        [B1]=707
        [B2]=500
        [B3]=353
        [B4]=250
        [B5]=176
        [B6]=125
        [LETTER]=216
        [LEGAL]=216
        [TABLOID]=279
        [LEDGER]=432
    )

    declare -A expected_height=(
        [A0]=1189
        [A1]=841
        [A2]=594
        [A3]=420
        [A4]=297
        [A5]=210
        [A6]=148
        [B0]=1414
        [B1]=1000
        [B2]=707
        [B3]=500
        [B4]=353
        [B5]=250
        [B6]=176
        [LETTER]=279
        [LEGAL]=356
        [TABLOID]=432
        [LEDGER]=279
    )

    for format in "${!expected_width[@]}"; do
        width=
        height=

        _paper_get_format_sizes "${format}" width height

        assert_same "${expected_width[$format]}" "${width}"
        assert_same "${expected_height[$format]}" "${height}"
    done
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_paper_get_format_sizes_case_insensitive()
{
    local width=
    local height=

    _paper_get_format_sizes "a4" width height

    assert_same "210" "${width}"
    assert_same "297" "${height}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_paper_get_format_sizes_unsupported_format()
{
    local exit_code=0
    local width=
    local height=

    _paper_get_format_sizes "A7" width height || exit_code=$?

    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_paper_get_format_sizes_missing_format()
{
    local exit_code=0
    local width=
    local height=

    _paper_get_format_sizes "" width height || exit_code=$?

    assert_same "1" "${exit_code}"
}
