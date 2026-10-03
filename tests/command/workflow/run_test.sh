#!/usr/bin/env bash

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function set_up()
{
    export TEST_HOME="/tmp/bashunit_run_test_$$"
    mkdir -p "${TEST_HOME}"
    export HOME="${TEST_HOME}"

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/command/workflow/run.sh"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function tear_down()
{
    rm -rf -- "${TEST_HOME}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_run_no_args_shows_usage()
{
    local exit_code=0
    local output

    output="$(command_workflow_run)" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_contains "Runs a workflow script" "${output}"
    assert_contains "Usage:" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_run_invalid_workflow_name()
{
    local exit_code=0

    ( command_workflow_run "../invalid_name" ) >/dev/null 2>&1 || exit_code=$?
    assert_not_same "0" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_run_non_existent_workflow()
{
    local exit_code=0

    ( command_workflow_run "does_not_exist_xyz" ) >/dev/null 2>&1 || exit_code=$?
    assert_not_same "0" "${exit_code}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_run_default_echo_workflow()
{
    local exit_code=0
    local output

    # _config_load_workflow creates the default workflow "echo"
    output="$(command_workflow_run "echo" "foo" "bar")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "foo bar" "${output}"
}

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function test_command_workflow_run_custom_workflow()
{
    local exit_code=0
    local output

    _config_load_workflow

    local -r custom_wf="${HOME}/.local/share/pdfmt/workflows/test-script"
    cat <<'EOF' > "${custom_wf}"
#!/usr/bin/env bash
# =========
# Custom workflow description
echo "run_OK: $1 - $2"
EOF
    chmod +x "${custom_wf}"


    output="$(command_workflow_run "test-script" "param1" "param2")" || exit_code=$?
    assert_same "0" "${exit_code}"
    assert_same "run_OK: param1 - param2" "${output}"
}
