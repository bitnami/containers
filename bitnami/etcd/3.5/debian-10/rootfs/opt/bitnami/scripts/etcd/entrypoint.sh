#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load etcd environment variables
. /opt/bitnami/scripts/etcd-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/etcd/run.sh" ]]; then
    info "** Starting etcd setup **"
    /opt/bitnami/scripts/etcd/setup.sh
    info "** etcd setup finished! **"
fi

echo ""
exec "$@"
