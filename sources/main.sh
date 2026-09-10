function main()
{
    set -euo pipefail

    trap _cleanup EXIT INT TERM

    # Check core dependencies for PDF manipulation
    _assert_installed awk
    _assert_installed basename
    _assert_installed cat
    _assert_installed find
    _assert_installed grep
    _assert_installed head
    _assert_installed mktemp
    _assert_installed pdftk
    _assert_installed sed
    _assert_installed seq
    _assert_installed tr
    _assert_installed xargs

    local -r command="${1:-}"
    [[ -n "${command}" ]] && shift

    case "${command}" in
        extract) command_extract "$@" ;;
        merge) command_merge "$@" ;;
        remove) command_remove "$@" ;;
        scan) command_scan "$@" ;;
        sort) command_sort "$@" ;;
        split) command_split "$@" ;;
        stamp) command_stamp "$@" ;;

        version|--version|-v) command_version "$@" ;;
        help|--help|-h|'') command_help "$@" ;;
        *)  _log_error "Unknown command '$command'"; return 1; ;;
    esac
}
