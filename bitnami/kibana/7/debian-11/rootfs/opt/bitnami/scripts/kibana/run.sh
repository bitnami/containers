#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libkibana.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

# Load environment
. /opt/bitnami/scripts/kibana-env.sh

info "** Starting Kibana **"
start_command=("${KIBANA_BIN_DIR}/kibana" "serve")
if am_i_root; then
    exec gosu "$KIBANA_DAEMON_USER" "${start_command[@]}"
else
    exec "${start_command[@]}"
fi
