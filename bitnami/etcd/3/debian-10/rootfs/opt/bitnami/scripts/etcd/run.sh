#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load etcd environment variables
. /opt/bitnami/scripts/etcd-env.sh

# Constants
EXEC="$(command -v etcd)"
declare -a args=("$@")

! is_empty_value "$ETCD_ROOT_PASSWORD" && unset ETCD_ROOT_PASSWORD
info "** Starting etcd **"
if am_i_root; then
    exec gosu "$ETCD_DAEMON_USER" "${EXEC}" "${args[@]}"
else
    exec "${EXEC}" "${args[@]}"
fi
