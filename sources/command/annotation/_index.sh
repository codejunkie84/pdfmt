function command_annotation()
{
    local -r command="${1:-}"
    [[ -n "${command}" ]] && shift

    case "${command}" in
        list) command_annotation_list "$@" ;;
        remove) command_annotation_remove "$@" ;;
        show) command_annotation_show "$@" ;;

        help|--help|-h|'') command_annotation_help "$@" ;;
        *)  _log_error "Unknown command '$command'"; return 1; ;;
    esac
}
