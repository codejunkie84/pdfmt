#######################################################################################################################
# Determines and prints the total number of pages of a given PDF file.
#
# Usage:
#   pdf_get_num_pages "test.pdf"
#   pdf_get_num_pages "test.pdf"
#
# Arguments:
#   $1: Input file
# Outputs:
#   - Outputs a message to STDERR if the total number of pages can not be determined
#   - The number of pages
# Returns:
#   0 on success, exits with RC=1 on failure
#######################################################################################################################
function _pdf_get_num_pages()
{
    local -r input_file="${1}"

    _assert_is_file "${input_file}" "Unable to determine the total number of pages" || return 1

    local -r num_pages=$(pdftk "${input_file}" dump_data | grep NumberOfPages | awk '{print $2}')

    _assert_is_not_empty "${num_pages}" "Unable to determine the total number of pages" || return $?

    echo "$num_pages"
}

#######################################################################################################################
# Parse a comma-separated range string (e.g., "1-3,5,8-10") into individual pages.
#
# Usage:
#
# Arguments:
#   $1 - The range string (e.g., "1-3,5")
#   $2 - (Optional) Max pages of the PDF to validate against bounds
# Outputs:
#   - Prints a space-separated list of valid pages
# Returns:
#   0 if successful, 1 if parsing fails or bounds are exceeded
#######################################################################################################################
function _pdf_parse_ranges()
{
    local range_string="${1:-}"
    local max_pages="${2:-}"

    local -a parsed_pages=()

    if [[ -z "$range_string" ]]; then
        _log_error "Range is empty."
        return 1
    fi

    # Split string into an array based on commas
    local -a parts
    IFS=',' read -ra parts <<< "$range_string"

    for part in "${parts[@]}"; do
        # remove white spaces (if user enters: "1-3, 5")
        part="${part// /}"

        if [[ "$part" =~ ^([1-9][0-9]*)-([1-9][0-9]*)$ ]]; then
            # case: range like 1-3
            local start="${BASH_REMATCH[1]}"
            local end="${BASH_REMATCH[2]}"

            if (( start > end )); then
                _log_error "Invalid range '$part' (start > end)."
                return 1
            fi

            if [[ -n "$max_pages" ]] && (( end > max_pages )); then
                _log_error "Range '$part' exceeds total pages ($max_pages)."
                return 1
            fi

            if (( end - start > 1000 )); then
                _log_error "Page range too large. Max page range is 1000."
                return 1
            fi

            for (( i=start; i<=end; i++ )); do
                parsed_pages+=("$i")
            done

        elif [[ "$part" =~ ^[1-9][0-9]*$ ]]; then
            # case: single page
            if [[ -n "$max_pages" ]] && (( part > max_pages )); then
                _log_error "Page '$part' exceeds total pages ($max_pages)."
                return 1
            fi
            parsed_pages+=("$part")

        else
            # case: invalid format
            _log_error "Error: Invalid format in range part '$part'."
            return 1
        fi
    done

    echo "${parsed_pages[@]}"
}
