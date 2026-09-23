#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    export TEST_HOME="/tmp/bashunit_config_test_$$"
    export HOME="${TEST_HOME}"

    mkdir -p "${HOME}/.config/pdfmt"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "${TEST_HOME}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_config_get_value()
{
    local config_file="${HOME}/.config/pdfmt/test.conf"

    cat > "${config_file}" <<EOF
test.value=hello world
test.number=123
test.color="#DC143C"
EOF

    assert_same "hello world" "$(_config_get_value "${config_file}" "test.value")"
    assert_same "123" "$(_config_get_value "${config_file}" "test.number")"
    assert_same "#DC143C" "$(_config_get_value "${config_file}" "test.color")"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_config_load_scan()
{
    cat > "${HOME}/.config/pdfmt/scan.conf" <<EOF
scan.device=test:scanner
scan.source.adf=TestADF
scan.source.flatbed=TestFlatbed
scan.resolution=600
scan.mode=Gray
scan.paper.format=A5
EOF

    _config_load_scan

    assert_same "test:scanner" "${SCAN_DEVICE}"
    assert_same "TestADF" "${SCAN_SOURCE_ADF}"
    assert_same "TestFlatbed" "${SCAN_SOURCE_FLATBED}"
    assert_same "600" "${SCAN_RESOLUTION}"
    assert_same "Gray" "${SCAN_MODE}"
    assert_same "A5" "${SCAN_PAPER_FORMAT}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_config_load_stamp_text()
{
    cat > "${HOME}/.config/pdfmt/stamp_text.conf" <<EOF
stamp.text.font.file=/tmp/test-font.ttf
stamp.text.font.size=42
stamp.text.font.color="#00FF00"
EOF

    _config_load_stamp_text

    assert_same "/tmp/test-font.ttf" "${STAMP_TEXT_FONT_FILE}"
    assert_same "42" "${STAMP_TEXT_FONT_SIZE}"
    assert_same "#00FF00" "${STAMP_TEXT_FONT_COLOR}"
}
