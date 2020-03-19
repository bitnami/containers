#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libmysql.sh

# Load MySQL environment variables
eval "$(mysql_env)"

print_welcome_page

if [[ "$*" = "/opt/bitnami/scripts/mysql/run.sh" ]]; then
    info "** Starting MySQL setup **"
    /opt/bitnami/scripts/mysql/setup.sh
    info "** MySQL setup finished! **"
fi

echo ""
exec "$@"
