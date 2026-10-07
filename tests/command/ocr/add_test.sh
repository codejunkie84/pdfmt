#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/ocr/add.sh"

    export TEST_DIR="/tmp/bashunit_test_$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR" || exit 1

    export HOME="${TEST_DIR}"

    mkdir -p "${HOME}/.config/pdfmt"
    cat > "${HOME}/.config/pdfmt/ocr.conf" <<EOF
ocr.language=eng
ocr.plugin=
EOF
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "$TEST_DIR"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_ocr_add()
{
    local exit_code=0
    local output

    output="$(command_ocr_add "${ROOT_DIR}/tests/_data/no-ocr.pdf" output.pdf)" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "" "${output}"
    assert_same "output.pdf" "$(printf '%s\n' *)"
    assert_same "PDFwithnoOCR" "$(pdftotext output.pdf - | tr -d '[:space:]')"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_ocr_add_input_file_not_existing()
{
    local exit_code=0
    local output

    output="$(command_ocr_add "${ROOT_DIR}/tests/_data/unknown-file.pdf" output.pdf)" || exit_code=$?
    assert_same "1" "${exit_code}"
    assert_same "" "${output}"
    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_ocr_add_ocr_already_exists()
{
    local exit_code=0
    local output

    output="$(command_ocr_add "${ROOT_DIR}/tests/_data/pages.pdf" output.pdf)" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "" "${output}"
    assert_not_same "output.pdf" "$(printf '%s\n' *)"
}
