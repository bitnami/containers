#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load harbor-registryctl environment
. /opt/bitnami/scripts/harbor-registryctl-env.sh

CMD="$(command -v harbor_registryctl)"
FLAGS=("-c" "/etc/registryctl/config.yml" "$@")

info "** Starting harbor-registryctl **"
if am_i_root; then
    exec gosu "$HARBOR_REGISTRYCTL_DAEMON_USER" "$CMD" "${FLAGS[@]}"
else
    exec "$CMD" "${FLAGS[@]}"
fi
