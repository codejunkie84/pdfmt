#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    export TEST_HOME="/tmp/bashunit_config_test_$$"
    export HOME="${TEST_HOME}"

    mkdir -p "${TEST_HOME}/.config/pdfmt"
    mkdir -p "${TEST_HOME}/bin"

    cat > "${TEST_HOME}/.config/pdfmt/scan.conf" <<EOF
scan.device=test:scanner
scan.source.adf=ADF
scan.source.flatbed=Flatbed
scan.resolution=300
scan.mode=Color
scan.paper.format=A4
EOF

    cat > "${TEST_HOME}/bin/scanimage" <<EOF
#!/usr/bin/env bash

output_file=

for argument in "\$@"; do
    if [[ "\$argument" == --batch=* ]]; then
        output_file="\${argument#--batch=}"
    fi
done

if [[ -n "\${output_file}" ]]; then
    output_file="\${output_file//%03d/001}"
    cp "${ROOT_DIR}/tests/_data/scan.png" "\${output_file}"
else
    cat "${ROOT_DIR}/tests/_data/scan.png"
fi
EOF

    chmod +x "${TEST_HOME}/bin/scanimage"

    export PATH="${TEST_HOME}/bin:${PATH}"

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/scan/_execute.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "${TEST_HOME}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_scan_execute_adf()
{
    local exit_code=0
    local -r output_file="${TEST_HOME}/scan.pdf"

    _command_scan_execute \
        adf \
        "${output_file}" || exit_code=$?

    assert_same "0" "${exit_code}"
    assert_file_exists "${output_file}"

    local -r num_pages="$(_pdf_get_num_pages "${output_file}")"

    assert_same "1" "${num_pages}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_scan_execute_scanimage_fails()
{
    local exit_code=0
    local -r output_file="${TEST_HOME}/scan.pdf"

    cat > "${TEST_HOME}/bin/scanimage" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF

    chmod +x "${TEST_HOME}/bin/scanimage"

    _command_scan_execute \
        adf \
        "${output_file}" || exit_code=$?

    assert_same "1" "${exit_code}"
}
