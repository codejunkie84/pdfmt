function _command_scan_execute()
{
    local -r command="${1:-}"
    local -r output_file="${2:-}"

    # Load
    # -----------------------------------------------------------------------------------------------------------------
    _config_load_scan


    # Validate
    # -----------------------------------------------------------------------------------------------------------------
    _assert_is_not_file "${output_file}" || return $?

    if [[ -z "${SCAN_DEVICE}" ]]; then
        _log_error "No scanner device configured. Please check ~/.config/pdfmt/scan.conf"
        return 1
    fi

    local source=
    if [[ "$command" == "adf" ]]; then
        source="$SCAN_SOURCE_ADF"
    elif [[ "$command" == "flatbed" ]]; then
        source="$SCAN_SOURCE_FLATBED"
    else
        _log_error "Command not implemented: $command"
        return 1
    fi

    local width=
    local height=
    if ! _paper_get_format_sizes "${SCAN_PAPER_FORMAT}" width height; then
        _log_error "Could not determine paper dimensions"
        return 1
    fi

    # Handle
    # -----------------------------------------------------------------------------------------------------------------
    local -r temp_dir="$(mktemp -d)"
    FILES_TO_CLEANUP+=("$temp_dir")

    if [[ "$command" == "adf" ]]; then
        scanimage \
            --device-name="$SCAN_DEVICE" \
            --source="$source" \
            --format=png \
            --mode="$SCAN_MODE" \
            --resolution="$SCAN_RESOLUTION" \
            -x "$width" \
            -y "$height" \
            --batch="$temp_dir/page_%03d.png"
    else
        scanimage \
            --device-name="$SCAN_DEVICE" \
            --source="$source" \
            --format=png \
            --mode="$SCAN_MODE" \
            --resolution="$SCAN_RESOLUTION" \
            -x "$width" \
            -y "$height" > "$temp_dir/page_001.png"
    fi

    if [[ ! -f "$temp_dir/page_001.png" ]]; then
        _log_error "No pages found in ADF or scanner not ready."
        return 1
    fi

    convert "$temp_dir"/*.png -compress jpeg -quality 85% -page "$SCAN_PAPER_FORMAT" "$output_file"
}
