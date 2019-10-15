#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /libpostgresql.sh

# Load PostgreSQL environment variables
eval "$(postgresql_env)"
export MODULE=postgresql

print_welcome_page

# Enable the nss_wrapper settings
postgresql_enable_nss_wrapper

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting PostgreSQL setup **"
    /setup.sh
    touch "$POSTGRESQL_TMP_DIR"/.initialized
    info "** PostgreSQL setup finished! **"
fi

echo ""
exec "$@"
