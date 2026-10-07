function command_ocr()
{
    local -r command="${1:-}"
    [[ -n "${command}" ]] && shift

    case "${command}" in
        add) command_ocr_add "$@" ;;
        exists) command_ocr_exists "$@" ;;
        show) command_ocr_show "$@" ;;

        help|--help|-h|'') command_ocr_help "$@" ;;
        *)  _log_error "Unknown command '$command'"; return 1; ;;
    esac
}
