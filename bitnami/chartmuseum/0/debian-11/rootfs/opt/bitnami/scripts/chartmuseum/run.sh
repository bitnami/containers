#!/bin/bash
#
# Bitnami Chartmuseum run

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

FLAGS=()
STORAGE="${STORAGE:-local}"

if [[ "$STORAGE" = "local" ]]; then
    info "Using local storage into /bitnami/data directory"
    STORAGE_LOCAL_ROOTDIR='/bitnami/data'
    FLAGS+=("--storage" "$STORAGE" "--storage-local-rootdir" "$STORAGE_LOCAL_ROOTDIR")
fi

info "** Starting chartmuseum **"
EXEC=/opt/bitnami/chartmuseum/bin/chartmuseum
if [[ "${#FLAGS[@]}" -gt 0 ]]; then
    exec "$EXEC" "${FLAGS[@]}"
else
    exec "$EXEC"
fi
