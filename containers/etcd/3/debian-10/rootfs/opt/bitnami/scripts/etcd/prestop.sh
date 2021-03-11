#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset

# Load libraries
. /opt/bitnami/scripts/libetcd.sh

# Load etcd environment settings
. /opt/bitnami/scripts/etcd-env.sh

read -r -a extra_flags <<< "$(etcdctl_auth_flags)"
extra_flags+=("--endpoints=$(etcdctl_get_endpoints)" "--debug=true")
etcdctl member remove "$(cat "${ETCD_DATA_DIR}/member_id")" "${extra_flags[@]}" > "$(dirname "$ETCD_DATA_DIR")/member_removal.log"
