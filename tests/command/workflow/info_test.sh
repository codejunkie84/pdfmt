#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    export TEST_HOME="/tmp/bashunit_info_test_$$"
    mkdir -p "${TEST_HOME}"
    export HOME="${TEST_HOME}"

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/workflow/info.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "${TEST_HOME}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_info_no_args_shows_usage()
{
    local exit_code=0
    local output

    output="$(command_workflow_info)" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "Shows information about a workflow" "${output}"
    assert_contains "Usage:" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_info_invalid_workflow_name()
{
    local exit_code=0

    ( command_workflow_info "../invalid_name" ) >/dev/null 2>&1 || exit_code=$?
    assert_not_same "0" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_info_non_existent_workflow()
{
    local exit_code=0

    ( command_workflow_info "does_not_exist_xyz" ) >/dev/null 2>&1 || exit_code=$?
    assert_same "1" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_info_default_echo_workflow()
{
    local exit_code=0
    local output

    output="$(command_workflow_info "echo")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "Workflow:     echo" "${output}"
    assert_contains "Description:  Write arguments to the standard output" "${output}"
    assert_contains "Using:        ${HOME}/.local/share/pdfmt/workflows/echo" "${output}"
    assert_contains "Paths:" "${output}"
    assert_contains "  ${HOME}/.local/share/pdfmt/workflows/echo" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_info_multiple_paths()
{
    local exit_code=0
    local output

    local path1="${TEST_HOME}/dir1"
    local path2="${TEST_HOME}/dir2"
    mkdir -p "${path1}" "${path2}"

    # create custom config, because command_workflow_info uses _config_load_workflow
    local config_dir="${HOME}/.config/pdfmt"
    mkdir -p "${config_dir}"
    cat <<EOF > "${config_dir}/workflow.conf"
workflow.paths=${path1}:${path2}
EOF

    # workflow 1
    cat <<'EOF' > "${path1}/my-flow"
#!/usr/bin/env bash
# =========
# First version description
EOF
    chmod +x "${path1}/my-flow"

    # workflow 2 (overwrites workflow 1 in hierarchy)
    cat <<'EOF' > "${path2}/my-flow"
#!/usr/bin/env bash
# =========
# Second version description
EOF
    chmod +x "${path2}/my-flow"

    output="$(command_workflow_info "my-flow")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "Workflow:     my-flow" "${output}"
    assert_contains "Description:  Second version description" "${output}"
    assert_contains "Using:        ${path2}/my-flow" "${output}"

    local expected_paths_block="Paths:"$'\n'"  ${path1}/my-flow"$'\n'"  ${path2}/my-flow"
    assert_contains "${expected_paths_block}" "${output}"
}
