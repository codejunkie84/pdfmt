function command_workflow_run()
{
    if (( $# < 1 )); then
        cat <<TEXT
Runs a workflow script

Usage:
  pdfmt workflow run <workflow name> [arguments]

Examples:
  pdfmt workflow run echo document.pdf

TEXT
        return 0
    fi

    # Load
    # -----------------------------------------------------------------------------------------------------------------
    _config_load_workflow

    local -r workflow_name="$1"
    shift


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _workflow_assert_valid_name "${workflow_name}" || return $?

    local -r workflow_file="$(_workflow_find "${workflow_name}")"
    _assert_is_not_empty "${workflow_file}" "No executable workflow found with name: ${workflow_name}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    exec "${workflow_file}" "$@"
}
