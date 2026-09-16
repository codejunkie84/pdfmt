#######################################################################################################################
# Asserts that the given program is installed.
#
# Usage:
#   _assert_is_installed "tar"
#   _assert_is_installed "tar" "tar is not installed"
#
# Arguments:
#   $1: Name of the program
#   $2: (optional) Custom assertion failure message
# Outputs:
#   Outputs a message to STDERR if the assertion fails
# Returns:
#   0 on success, 1 on failure
#######################################################################################################################
function _assert_is_installed()
{
    local -r program="${1:-}"
    local -r message="${2:-Could not find program "$program" in "\$PATH", or it is not executable}"
    if ! command -v "$program" >/dev/null 2>&1; then
        _log_error "${message}"
        return 1
    fi
}

#######################################################################################################################
# Asserts whether a given file (not a directory) exists.
#
# Usage:
#   _assert_is_file "/path/to/file"
#   _assert_is_file "/path/to/file" "Interchange file does not exist"
#
# Globals:
#   None
# Arguments:
#   $1: Path to file
#   $2: (optional) Custom assertion failure message
# Outputs:
#   Outputs a message to STDERR if the assertion fails
# Returns:
#   0 on success, 1 on failure
#######################################################################################################################
function _assert_is_file()
{
    local -r path="${1:-}"
    local -r message="${2:-File does not exist: "$path"}"

    if [[ ! -f "$path" ]]; then
        _log_error "${message}"
        return 1
    fi
}

#######################################################################################################################
# Asserts whether a given file does not exists.
#
# Usage:
#   _assert_is_not_file "/path/to/file"
#   _assert_is_not_file "/path/to/file" "Output file already exist"
#
# Globals:
#   None
# Arguments:
#   $1: Path to file
#   $2: (optional) Custom assertion failure message
# Outputs:
#   Outputs a message to STDERR if the assertion fails
# Returns:
#   0 on success, 1 on failure
#######################################################################################################################
function _assert_is_not_file()
{
    local -r path="${1:-}"
    local -r message="${2:-File already exists: ${path}}"

    if [[ -f "$path" ]]; then
        _log_error "${message}"
        return 1
    fi
}

#######################################################################################################################
# Asserts whether a given string is not empty.
#
# Usage:
#   _assert_is_not_empty "$value_to_check"
#   _assert_is_not_empty "$value_to_check" "No value set"
#
# Globals:
#   None
# Arguments:
#   $1: Value to check
#   $2: (optional) Custom assertion failure message
# Outputs:
#   Outputs a message to STDERR if the assertion fails
# Returns:
#   0 on success, 1 on failure
#######################################################################################################################
function _assert_is_not_empty()
{
    local -r value="${1:-}"
    local -r message="${2:-Value not set}"

    if [[ -z "$value" ]]; then
        _log_error "${message}"
        return 1
    fi
}

#######################################################################################################################
# Asserts that all characters in the given value are numeric.
#
# Usage:
#   _assert_is_digit "$value_to_check"
#   _assert_is_digit "$value_to_check" "Offset contains non-digit characters"
#
# Globals:
#   None
# Arguments:
#   $1: Value to check
#   $2: (optional) Custom assertion failure message
# Outputs:
#   Outputs a message to STDERR if the assertion fails
# Returns:
#   0 on success, 1 on failure
#######################################################################################################################
function _assert_is_digit()
{
    local -r value="${1:-}"
    local -r message="${2:-The value does not consist entirely of digits: "${value}"}"

    if [[ ! "$value" =~ ^[0-9]+$ ]]; then
        _log_error "${message}"
        return 1
    fi
}
