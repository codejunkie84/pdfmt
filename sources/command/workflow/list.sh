function command_workflow_list()
{
    # Needed for generate-command-overview.sh
    cat <<TEXT > /dev/null
Lists all available workflow scripts
TEXT

    # Load
    # -----------------------------------------------------------------------------------------------------------------
    _config_load_workflow


    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -A workflows=()
    local path workflow workflow_name description

    while IFS= read -r path; do
        for workflow in "${path}"/*; do
            [[ -f "${workflow}" ]] || continue
            [[ -x "${workflow}" ]] || continue

            workflow_name="${workflow##*/}"
            workflows["${workflow_name}"]="${workflow}"
        done
    done < <(_workflow_get_paths)

    if (( ${#workflows[@]} == 0 )); then
        _log_warning "No workflows found."
        return 0
    fi

    local name
    while IFS= read -r name; do
        description="$(_workflow_get_description "${workflows[${name}]}")"
        printf '%-20s %s\n' "${name}" "${description}"
    done < <(printf '%s\n' "${!workflows[@]}" | sort)
}
