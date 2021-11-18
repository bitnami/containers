#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libetcd.sh

# Load etcd environment settings
. /opt/bitnami/scripts/etcd-env.sh

endpoints="$(etcdctl_get_endpoints true)"
if is_empty_value "${endpoints}"; then
    exit 0
fi
read -r -a extra_flags <<< "$(etcdctl_auth_flags)"
extra_flags+=("--endpoints=${endpoints}" "--debug=true")
etcdctl member remove "$(cat "${ETCD_DATA_DIR}/member_id")" "${extra_flags[@]}" > "$(dirname "$ETCD_DATA_DIR")/member_removal.log"
