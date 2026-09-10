function command_extract()
{
    local -r command="${1:-}"
    [[ -n "${command}" ]] && shift

    case "${command}" in
        even) command_extract_even "$@" ;;
        odd) command_extract_odd "$@" ;;
        range) command_extract_range "$@" ;;

        help|--help|-h|'') command_extract_help "$@" ;;
        *)  _log_error "Unknown command '$command'"; return 1; ;;
    esac
}
