#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Redmine environment
. /opt/bitnami/scripts/redmine-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/redmine/run.sh" ]]; then
    /opt/bitnami/scripts/mysql-client/setup.sh
    /opt/bitnami/scripts/postgresql-client/setup.sh
    /opt/bitnami/scripts/redmine/setup.sh
    /post-init.sh
    info "** Redmine setup finished! **"
fi

echo ""
exec "$@"
