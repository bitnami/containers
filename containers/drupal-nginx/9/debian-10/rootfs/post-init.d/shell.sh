#!/bin/bash
#
# Post-init script to execute Shell files

# shellcheck disable=SC1090,SC1091

# set -o xtrace # Uncomment this line for debugging purposes

. /opt/bitnami/base/functions

readonly f="${1:?missing SHELL file}"
failure=0

if [[ "$f" == *".sh" ]]; then
    if [[ -x "$f" ]]; then
        info "Executing $f"; "$f" || failure=$?
    else
        info "Sourcing $f"; . "$f"
    fi
fi
if [[ "$failure" -ne 0 ]]; then
    error "Failed to execute ${f}"
    exit "$failure"
fi
