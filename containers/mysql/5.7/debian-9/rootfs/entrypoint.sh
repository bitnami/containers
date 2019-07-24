#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /libmysql.sh

# Load MySQL environment variables
eval "$(mysql_env)"

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting MySQL setup **"
    /setup.sh
    touch "$DB_VOLUMEDIR"/.mysql_initialized
    info "** MySQL setup finished! **"
fi

echo ""
exec "$@"
