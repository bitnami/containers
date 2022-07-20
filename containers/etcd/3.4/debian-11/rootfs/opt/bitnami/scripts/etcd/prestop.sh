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

if is_boolean_yes "$ETCD_DISABLE_PRESTOP"; then
    return 0
fi

endpoints="$(etcdctl_get_endpoints true)"
if is_empty_value "${endpoints}"; then
    exit 0
fi
read -r -a extra_flags <<<"$(etcdctl_auth_flags)"
extra_flags+=("--endpoints=${endpoints}" "--debug=true")
# We use 'sync' to ensure memory buffers are flushed to disk
# so we reduce the chances that the "member_removal.log" file is empty.
# ref: https://man7.org/linux/man-pages/man1/sync.1.html
etcdctl member remove "$(get_member_id)" "${extra_flags[@]}" >"$(dirname "$ETCD_DATA_DIR")/member_removal.log"
sync -d "$(dirname "$ETCD_DATA_DIR")/member_removal.log"
