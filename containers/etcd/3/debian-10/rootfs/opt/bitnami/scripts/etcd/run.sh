#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libetcd.sh

# Load etcd environment variables
. /opt/bitnami/scripts/etcd-env.sh

# Constants
EXEC="$(command -v etcd)"

! is_empty_value "$ETCD_ROOT_PASSWORD" && unset ETCD_ROOT_PASSWORD
if [[ -f "$ETCD_NEW_MEMBERS_ENV_FILE" ]]; then
    debug "Loading env vars of existing cluster"
    . "$ETCD_NEW_MEMBERS_ENV_FILE"
else
    # We do not rely on the original value of ETCD_INITIAL_CLUSTER even
    # when bootstrapping a new cluster since we cannot assume
    # that all nodes will come-up healthy
    ETCD_INITIAL_CLUSTER="$(recalculate_initial_cluster)"
    export ETCD_INITIAL_CLUSTER
fi

info "** Starting etcd **"
if am_i_root; then
    exec gosu "$ETCD_DAEMON_USER" "${EXEC}" "$@"
else
    exec "${EXEC}" "$@"
fi
