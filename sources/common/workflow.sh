#######################################################################################################################
# Asserts that the given value is a valid workflow name.
#
# Usage:
#   _workflow_assert_valid_name "$workflow"
#
# Globals:
#   None
# Arguments:
#   $2: Workflow name
# Outputs:
#   Outputs a message to STDERR if the assertion fails
# Returns:
#   0 on success, 1 on failure
#######################################################################################################################
function _workflow_assert_valid_name()
{
    local -r workflow_name="${1:-}"

    _assert_matches_regex \
        '^[^/]+$' \
        "${workflow_name}" \
        "Invalid workflow name: ${workflow_name}" || return $?
}

#######################################################################################################################
# Displays all paths where workflow scripts can be located.
#
# Usage:
#   _workflow_get_paths
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   All paths where workflow scripts can be located
# Returns:
#   0 on success, 1 on failure
#######################################################################################################################
function _workflow_get_paths()
{
    local path

    IFS=':' read -ra paths <<< "${WORKFLOW_PATHS}"
    for path in "${paths[@]}"; do
        # remove leading and trailing whitespace
        path="${path#"${path%%[![:space:]]*}"}"
        path="${path%"${path##*[![:space:]]}"}"
        # remove trailing /
        path="${path%/}"

        [[ -z "${path}" ]] && continue

        printf '%s\n' "${path}"
    done
}

#######################################################################################################################
# Determines the used path of a given workflow. If there are multiple paths the last will be used.
#
# Usage:
#   _workflow_find "$workflow"
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Used path of the given workflow
# Returns:
#   0 on success, 1 on failure
#######################################################################################################################
function _workflow_find()
{
    local -r workflow_name="${1}"
    local -a workflow_files=()

    mapfile -t workflow_files < <(_workflow_find_all "${workflow_name}")
    if (( ${#workflow_files[@]} == 0 )); then
        return 0
    fi

    printf '%s\n' "${workflow_files[${#workflow_files[@]} - 1]}"
}

#######################################################################################################################
# Determines all paths of a given workflow.
#
# Usage:
#   _workflow_find_all "$workflow"
#
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Paths of a given workflow.
# Returns:
#   0 on success, 1 on failure
#######################################################################################################################
function _workflow_find_all()
{
    local -r workflow_name="${1}"
    local path workflow_file

    while IFS= read -r path; do
        workflow_file="${path}/${workflow_name}"

        [[ -x "${workflow_file}" ]] || continue

        printf '%s\n' "${workflow_file}"
    done < <(_workflow_get_paths)
}

#######################################################################################################################
# Displays the description of the given workflow script path.
#
# Usage:
#   _workflow_get_description "$workflow_file"
#
# Globals:
#   None
# Arguments:
#   $1: Path to workflow script
# Outputs:
#   The description of the workflow script
# Returns:
#   0 on success, 1 on failure
#######################################################################################################################
function _workflow_get_description()
{
    local -r workflow_file="${1}"

    sed -n '3s/^#[[:space:]]*//p' "${workflow_file}"
}
