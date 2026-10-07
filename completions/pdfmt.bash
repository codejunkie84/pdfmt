#!/usr/bin/env bash
# =====================================================================================================================
# Bash completion for pdfmt commands.
#
# =====================================================================================================================
function _pdfmt_completions()
{
    local current="${COMP_WORDS[COMP_CWORD]}"

    # Level 1: Main commands
    if [[ "$COMP_CWORD" -eq 1 ]]; then
        local commands="extract merge ocr remove scan sort split stamp version workflow help"
        mapfile -t COMPREPLY < <(compgen -W "$commands" -- "$current")
        return 0
    fi

    # Level 2: Sub commands
    if [[ "$COMP_CWORD" -eq 2 ]]; then
        case "${COMP_WORDS[1]}" in
            extract)  mapfile -t COMPREPLY < <(compgen -W "even odd range help" -- "$current") ;;
            merge)    mapfile -t COMPREPLY < <(compgen -W "all duplex insert help" -- "$current") ;;
            ocr)      mapfile -t COMPREPLY < <(compgen -W "add exists remove show help" -- "$current") ;;
            remove)   mapfile -t COMPREPLY < <(compgen -W "even odd range help" -- "$current") ;;
            scan)     mapfile -t COMPREPLY < <(compgen -W "adf flatbed help" -- "$current") ;;
            sort)     mapfile -t COMPREPLY < <(compgen -W "duplex move random reverse swap help" -- "$current") ;;
            split)    mapfile -t COMPREPLY < <(compgen -W "all length range help" -- "$current") ;;
            stamp)    mapfile -t COMPREPLY < <(compgen -W "text help" -- "$current") ;;
            workflow) mapfile -t COMPREPLY < <(compgen -W "info list run help" -- "$current") ;;
        esac
        return 0
    fi

    # Level 3+: Completion of PDF files
    mapfile -t COMPREPLY < <(compgen -f -X '!*.pdf' -- "$current")
}

complete -F _pdfmt_completions pdfmt
