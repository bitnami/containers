#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load harbor-notary-server environment
. /opt/bitnami/scripts/harbor-notary-server-env.sh

CMD="$(command -v notary-server)"
FLAGS=("-config=/etc/notary/server-config.postgres.json" "-logf=logfmt")

cd "$HARBOR_NOTARY_SERVER_BASE_DIR"

info "Running harbor-notary-server migrations"
migrations/migrate.sh

info "** Starting harbor-notary-server **"
if am_i_root; then
    exec gosu "$HARBOR_NOTARY_SERVER_DAEMON_USER" "$CMD" "${FLAGS[@]}"
else
    exec "$CMD" "${FLAGS[@]}"
fi
