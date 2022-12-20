#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load harbor-notary-signer environment
. /opt/bitnami/scripts/harbor-notary-signer-env.sh

CMD="$(command -v notary-signer)"
FLAGS=("-config=/etc/notary/signer-config.postgres.json" "-logf=logfmt")

cd "$HARBOR_NOTARY_SIGNER_BASE_DIR"

info "Running harbor-notary-signer migrations"
migrations/migrate.sh

info "** Starting harbor-notary-signer **"
if am_i_root; then
    exec gosu "$HARBOR_NOTARY_SIGNER_DAEMON_USER" "$CMD" "${FLAGS[@]}"
else
    exec "$CMD" "${FLAGS[@]}"
fi
