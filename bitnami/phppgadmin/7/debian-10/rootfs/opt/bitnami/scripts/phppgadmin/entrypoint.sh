#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load phpPgAdmin environment
. /opt/bitnami/scripts/phppgadmin-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/$(web_server_type)/run.sh" || "$1" = "/opt/bitnami/scripts/nginx-php-fpm/run.sh" ]]; then
    info "** Starting phpPgAdmin setup **"
    /opt/bitnami/scripts/"$(web_server_type)"/setup.sh
    /opt/bitnami/scripts/php/setup.sh
    /opt/bitnami/scripts/phppgadmin/setup.sh
    /post-init.sh
    info "** phpPgAdmin setup finished! **"
fi

echo ""
exec "$@"
