function command_remove()
{
    local -r command="${1:-}"
    [[ -n "${command}" ]] && shift

    case "${command}" in
        even) command_remove_even "$@" ;;
        odd) command_remove_odd "$@" ;;
        range) command_remove_range "$@" ;;

        help|--help|-h|'') command_remove_help "$@" ;;
        *)  _log_error "Unknown command '$command'"; return 1; ;;
    esac
}
