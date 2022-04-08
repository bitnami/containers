#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libmysql.sh

# Load MySQL environment variables
. /opt/bitnami/scripts/mysql-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/mysql/run.sh" ]]; then
    info "** Starting MySQL setup **"
    /opt/bitnami/scripts/mysql/setup.sh
    info "** MySQL setup finished! **"
fi

echo ""
exec "$@"
