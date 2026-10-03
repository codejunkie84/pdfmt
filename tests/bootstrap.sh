#!/usr/bin/env bash
set -euo pipefail

function bootstrap()
{
    local -r root_dir="$(cd "$(bashunit::current_dir)/.." && pwd -P)"
    export ROOT_DIR="$root_dir"

    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/assert.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/cleanup.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/config.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/log.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/paper.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/pdf.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/platform.sh"
    # shellcheck disable=SC1091     # ROOT_DIR is provided by the bootstrap.
    source "$ROOT_DIR/sources/common/workflow.sh"

}

bootstrap
