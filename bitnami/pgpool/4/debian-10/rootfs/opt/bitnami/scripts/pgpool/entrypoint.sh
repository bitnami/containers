#!/bin/bash
#
# Bitnami Pgpool entrypoint

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libpgpool.sh

# Load Pgpool env. variables
eval "$(pgpool_env)"

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/pgpool/run.sh"* ]]; then
    info "** Starting Pgpool-II setup **"
    /opt/bitnami/scripts/pgpool/setup.sh
    info "** Pgpool-II setup finished! **"
fi

echo ""
exec "$@"
