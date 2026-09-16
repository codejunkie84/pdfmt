function command_stamp()
{
    # Check dependencies for 'scan' command
    _assert_is_installed convert || return $?   # Part of ImageMagick
    _assert_is_installed identify || return $?  # Part of ImageMagick

    local -r command="${1:-}"
    [[ -n "${command}" ]] && shift

    case "${command}" in
        text) command_stamp_text "$@" ;;

        help|--help|-h|'') command_stamp_help "$@" ;;
        *)  _log_error "Unknown command '$command'"; return 1; ;;
    esac
}
