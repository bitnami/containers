#!/bin/bash
#
# Bitnami Pgpool entrypoint

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /liblog.sh
. /libpgpool.sh

# Load Pgpool env. variables
eval "$(pgpool_env)"

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Pgpool-II setup **"
    /setup.sh
    info "** Pgpool-II setup finished! **"
fi

echo ""
exec "$@"
