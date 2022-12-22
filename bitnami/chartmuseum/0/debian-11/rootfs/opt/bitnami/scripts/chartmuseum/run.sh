#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

# Load environment
. /opt/bitnami/scripts/chartmuseum-env.sh

CMD=("/opt/bitnami/chartmuseum/bin/chartmuseum")
STORAGE="${STORAGE:-local}"

if [[ "$STORAGE" = "local" ]]; then
    info "Using local storage into /bitnami/data directory"
    STORAGE_LOCAL_ROOTDIR='/bitnami/data'
    CMD+=("--storage" "$STORAGE" "--storage-local-rootdir" "$STORAGE_LOCAL_ROOTDIR")
fi

info "** Starting ChartMuseum **"
if am_i_root; then
    exec gosu "$CHARTMUSEUM_DAEMON_USER" "${CMD[@]}"
else
    exec "${CMD[@]}" "$@"
fi
