function command_workflow()
{
    # Check dependencies for 'workflow' command
    _assert_is_installed exec || return $?

    local -r command="${1:-}"
    [[ -n "${command}" ]] && shift

    case "${command}" in
        info) command_workflow_info "$@" || return $? ;;
        list) command_workflow_list "$@" || return $? ;;
        run) command_workflow_run "$@" || return $? ;;

        help|--help|-h|'') command_workflow_help "$@" ;;
        *)  _log_error "Unknown command '$command'"; return 1; ;;
    esac
}
