#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /libpostgresql.sh

# Load Redis environment variables
eval "$(postgresql_env)"

print_welcome_page

# Enable the nss_wrapper settings
postgresql_enable_nss_wrapper

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting PostgreSQL setup **"
    /setup.sh
    info "** PostgreSQL setup finished! **"
fi

echo ""
exec "$@"
