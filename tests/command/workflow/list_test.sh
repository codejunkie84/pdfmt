#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    export TEST_HOME="/tmp/bashunit_list_test_$$"
    mkdir -p "${TEST_HOME}"
    export HOME="${TEST_HOME}"

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/workflow/list.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "${TEST_HOME}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_list_default_echo()
{
    local exit_code=0
    local output

    # workflow "echo" is always available
    output="$(command_workflow_list)" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "echo" "${output}"
    assert_contains "Write arguments to the standard output" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_list_no_workflows()
{
    local exit_code=0
    local output

    # create an empty directory and set it into config
    local empty_dir="${TEST_HOME}/empty_workflows"
    mkdir -p "${empty_dir}"

    local config_dir="${HOME}/.config/pdfmt"
    mkdir -p "${config_dir}"
    cat <<EOF > "${config_dir}/workflow.conf"
workflow.paths=${empty_dir}
EOF

    output="$(command_workflow_list 2>&1)" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "No workflows found." "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_list_multiple_sorted_and_formatted()
{
    local exit_code=0
    local output

    local work_dir="${TEST_HOME}/workflows"
    mkdir -p "${work_dir}"

    local config_dir="${HOME}/.config/pdfmt"
    mkdir -p "${config_dir}/workflows"
    touch "${config_dir}/workflows/echo"

    cat <<EOF > "${config_dir}/workflow.conf"
workflow.paths=${work_dir}
EOF

    # workflow z
    cat <<'EOF' > "${work_dir}/z_workflow"
#!/usr/bin/env bash
# =========
# Description for Z
EOF
    chmod +x "${work_dir}/z_workflow"

    # workflow a
    cat <<'EOF' > "${work_dir}/a_workflow"
#!/usr/bin/env bash
# =========
# Description for A
EOF
    chmod +x "${work_dir}/a_workflow"

    output="$(command_workflow_list)" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "a_workflow           Description for A" "${output}"
    assert_contains "z_workflow           Description for Z" "${output}"

    local expected_output="a_workflow           Description for A"$'\n'"z_workflow           Description for Z"
    assert_contains "${expected_output}" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_list_ignores_non_executable_files()
{
    local exit_code=0
    local output

    local work_dir="${TEST_HOME}/workflows"
    mkdir -p "${work_dir}"

    local config_dir="${HOME}/.config/pdfmt"
    mkdir -p "${config_dir}"
    cat <<EOF > "${config_dir}/workflow.conf"
workflow.paths=${work_dir}
EOF

    # executable workflow script
    cat <<'EOF' > "${work_dir}/valid_flow"
#!/usr/bin/env bash
# =========
# Valid description
EOF
    chmod +x "${work_dir}/valid_flow"

    # non-executable workflow script
    cat <<'EOF' > "${work_dir}/ignored_flow"
#!/usr/bin/env bash
# =========
# Ignored description
EOF
    chmod -x "${work_dir}/ignored_flow"

    output="$(command_workflow_list)" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "valid_flow" "${output}"
    assert_not_contains "ignored_flow" "${output}"
}
