#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Grafana environment
. /opt/bitnami/scripts/grafana-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

function is_exec() {
    # This checks if the first provided argument is executable or if only args was used
    exec_in_path=$(builtin type -P "$1" 2> /dev/null)
    if [[ -f "$1" && -x $(realpath "$1" 2> /dev/null) || -x $(realpath "$exec_in_path" 2> /dev/null) ]]; then
        true;
    else
        false;
    fi;
}

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/grafana/run.sh" ]] || ! is_exec "$1"; then
    # This catches the error-code from libgrafana.sh for the immediate exit when the grafana-operator is used. And ensure that the exit code is kept silently.
    /opt/bitnami/scripts/grafana/setup.sh || GRAFANA_OPERATOR_IMMEDIATE_EXIT=$?
    if [[ "${GRAFANA_OPERATOR_IMMEDIATE_EXIT:-0}" -eq 255 ]]; then
        exit 0
    elif [[ "${GRAFANA_OPERATOR_IMMEDIATE_EXIT:-0}" -ne 0 ]]; then
        exit "$GRAFANA_OPERATOR_IMMEDIATE_EXIT"
    fi
    /post-init.sh
    info "** Grafana setup finished! **"
fi

echo ""

if is_exec "$1"; then
    exec "$@"
else
    exec "/opt/bitnami/scripts/grafana/run.sh" "$@"
fi
