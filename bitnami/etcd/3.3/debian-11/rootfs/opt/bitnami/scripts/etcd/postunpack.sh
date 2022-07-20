#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh

# Load etcd environment variables
. /opt/bitnami/scripts/etcd-env.sh

for dir in "$ETCD_BIN_DIR" "$ETCD_DATA_DIR" "${ETCD_BASE_DIR}/certs"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$ETCD_DATA_DIR" "${ETCD_BASE_DIR}/certs"
