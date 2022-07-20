#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load Symfony environment
. /opt/bitnami/scripts/symfony-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/symfony/run.sh"* ]]; then
    info "** Running Symfony setup **"
    /opt/bitnami/scripts/php/setup.sh
    /opt/bitnami/scripts/mysql-client/setup.sh
    /opt/bitnami/scripts/symfony/setup.sh
    info "** Symfony setup finished! **"
fi

echo ""
exec "$@"
