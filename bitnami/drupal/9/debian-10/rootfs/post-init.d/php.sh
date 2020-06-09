#!/bin/bash
#
# Post-init script to execute PHP files

# shellcheck disable=SC1091

# set -o xtrace # Uncomment this line for debugging purposes

. /opt/bitnami/base/functions

readonly f="${1:?missing PHP file}"
failure=0

if [[ "$f" == *".php" ]]; then
    info "Executing $f with PHP interpreter"
    php "$f" || failure=$?
fi
if [[ "$failure" -ne 0 ]]; then
    error "Failed to execute ${f}"
    exit "$failure"
fi
