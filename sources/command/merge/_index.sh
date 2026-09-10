function command_merge()
{
    local -r command="${1:-}"
    [[ -n "${command}" ]] && shift

    case "${command}" in
        all) command_merge_all "$@" ;;
        duplex) command_merge_duplex "$@" ;;
        insert) command_merge_insert "$@" ;;

        help|--help|-h|'') command_merge_help "$@" ;;
        *)  _log_error "Unknown command '$command'"; return 1; ;;
    esac
}
