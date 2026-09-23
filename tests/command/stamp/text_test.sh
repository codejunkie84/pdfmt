#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    export TEST_HOME="/tmp/bashunit_config_test_$$"
    export HOME="${TEST_HOME}"

    mkdir -p "${HOME}/.config/pdfmt"

    cat > "${HOME}/.config/pdfmt/stamp_text.conf" <<EOF
stamp.text.font.file=${ROOT_DIR}/tests/_data/DejaVuSans-Bold.ttf
stamp.text.font.size=22
stamp.text.font.color="#DC143C"
EOF

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/stamp/text.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "${TEST_HOME}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_stamp_text()
{
    local exit_code=0
    local -r input_file="${ROOT_DIR}/tests/_data/pages.pdf"
    local -r output_file="${TEST_HOME}/stamped.pdf"

    command_stamp_text \
        "${input_file}" \
        "TEST STAMP" \
        "${output_file}" || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_file_exists "${output_file}"

    local -r input_pages="$(_pdf_get_num_pages "${input_file}")"
    local -r output_pages="$(_pdf_get_num_pages "${output_file}")"

    assert_same "${input_pages}" "${output_pages}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_stamp_text_changes_rendered_page()
{
    local exit_code=0
    local -r input_file="${ROOT_DIR}/tests/_data/pages.pdf"
    local -r output_file="${TEST_HOME}/stamped.pdf"
    local -r before_file="${TEST_HOME}/before"
    local -r after_file="${TEST_HOME}/after"

    command_stamp_text \
        "${input_file}" \
        "TEST STAMP" \
        "${output_file}" || exit_code=$?

    assert_same "0" "${exit_code}"

    pdftoppm \
        -f 1 \
        -singlefile \
        -png \
        "${input_file}" \
        "${before_file}"

    pdftoppm \
        -f 1 \
        -singlefile \
        -png \
        "${output_file}" \
        "${after_file}"

    local difference
    difference="$(compare \
        -metric AE \
        "${before_file}.png" \
        "${after_file}.png" \
        null: 2>&1 || true)"

    assert_not_same "0" "${difference}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_stamp_text_input_file_not_existing()
{
    local exit_code=0
    local -r input_file="${TEST_HOME}/unknown-file.pdf"
    local -r output_file="${TEST_HOME}/stamped.pdf"

    command_stamp_text \
        "${input_file}" \
        "TEST STAMP" \
        "${output_file}" || exit_code=$?

    assert_same "1" "${exit_code}"
}
