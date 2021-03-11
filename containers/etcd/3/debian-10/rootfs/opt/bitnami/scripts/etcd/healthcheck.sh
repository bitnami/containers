#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libetcd.sh

# Load etcd environment settings
. /opt/bitnami/scripts/etcd-env.sh

host="$(parse_uri "$ETCD_ADVERTISE_CLIENT_URLS" "host")"
port="$(parse_uri "$ETCD_ADVERTISE_CLIENT_URLS" "port")"
read -r -a extra_flags <<< "$(etcdctl_auth_flags)"
extra_flags+=("--endpoints=${host}:${port}")
if etcdctl endpoint health "${extra_flags[@]}"; then
    exit 0
else
    error "Unhealthy endpoint!"
    exit 1
fi
