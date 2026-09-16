#######################################################################################################################
# Determines the dimensions of a paper format.
#
# Usage:
#   _paper_get_format_sizes A4 width height
#   _paper_get_format_sizes A5 width height
#
# Arguments:
#   $1: Paper format
#   $2: Variable name for width
#   $3: Variable name for height
#
# Outputs:
#   - Outputs an error message to STDERR if the paper format can not be determined
#   - Outputs an error message to STDERR if the output variables are missing
#
# Returns:
#   0 on success
#   1 on failure
#
#######################################################################################################################
function _paper_get_format_sizes()
{
    local -r format="${1}"
    local -n width_ref="${2}"   # Nameref for the target variable (width)
    local -n height_ref="${3}"  # Nameref for the target variable (height)

    _assert_is_not_empty "${format}" "No paper format given" || return $?
    _assert_is_not_empty "${2}" "Output variable for width is required" || return $?
    _assert_is_not_empty "${3}" "Output variable for height is required" || return $?

    local w=
    local h=

    case "${format^^}" in
        # ISO 216 - A series
        A0) w=841; h=1189 ;;
        A1) w=594; h=841 ;;
        A2) w=420; h=594 ;;
        A3) w=297; h=420 ;;
        A4) w=210; h=297 ;;
        A5) w=148; h=210 ;;
        A6) w=105; h=148 ;;

        # ISO 216 - B series
        B0) w=1000; h=1414 ;;
        B1) w=707;  h=1000 ;;
        B2) w=500;  h=707  ;;
        B3) w=353;  h=500  ;;
        B4) w=250;  h=353  ;;
        B5) w=176;  h=250  ;;
        B6) w=125;  h=176  ;;

        # Misc
        LETTER)  w=216; h=279 ;;
        LEGAL)   w=216; h=356 ;;
        TABLOID) w=279; h=432 ;;
        LEDGER)  w=432; h=279 ;;

        *)
            _log_error "Unsupported paper format: ${format}"
            return 1
            ;;
    esac

    # Write values directly to the reference variables
    # shellcheck disable=SC2034     # width_ref is a Nameref for the target variable
    width_ref="${w}"
    # shellcheck disable=SC2034     # height_ref is a Nameref for the target variable
    height_ref="${h}"

    return 0
}
