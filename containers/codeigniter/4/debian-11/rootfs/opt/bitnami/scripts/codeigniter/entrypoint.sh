#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load CodeIgniter environment
. /opt/bitnami/scripts/codeigniter-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/codeigniter/run.sh"* ]]; then
    info "** Running CodeIgniter setup **"
    /opt/bitnami/scripts/php/setup.sh
    /opt/bitnami/scripts/mysql-client/setup.sh
    /opt/bitnami/scripts/codeigniter/setup.sh
    info "** CodeIgniter setup finished! **"
fi

echo ""
exec "$@"
