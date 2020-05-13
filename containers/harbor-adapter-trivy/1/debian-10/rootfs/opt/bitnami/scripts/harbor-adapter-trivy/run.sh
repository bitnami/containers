#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/harboradaptertrivy-env.sh

cmd=$(command -v scanner-trivy)

info "** Starting Harbor Adapter Trivy **"
if am_i_root; then
    exec gosu "$SCANNER_TRIVY_DAEMON_USER" "${cmd}" "$@"
else
    exec "${cmd}" "$@"
fi
