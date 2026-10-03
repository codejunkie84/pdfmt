function command_workflow_info()
{
    if (( $# < 1 )); then
        cat <<TEXT
Shows information about a workflow

Usage:
  pdfmt workflow info <workflow name>

Example:
  pdfmt workflow info scan-duplex

TEXT
        return 0
    fi

    # Load
    # -----------------------------------------------------------------------------------------------------------------
    _config_load_workflow

    local -r workflow_name="$1"


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _workflow_assert_valid_name "${workflow_name}" || return $?


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -a workflow_files=()

    # Find
    mapfile -t workflow_files < <(_workflow_find_all "${workflow_name}")
    if (( ${#workflow_files[@]} == 0 )); then
        _log_error "No executable workflow found with name: ${workflow_name}"
        return 1
    fi

    # Output
    local -r workflow_file="${workflow_files[${#workflow_files[@]} - 1]}"
    local -r description="$(_workflow_get_description "${workflow_file}")"

    printf 'Workflow:     %s\n' "${workflow_name}"
    printf 'Description:  %s\n' "${description}"
    printf 'Using:        %s\n' "${workflow_file}"
    printf 'Paths:\n'

    local file
    for file in "${workflow_files[@]}"; do
        printf '  %s\n' "${file}"
    done
}
