#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

. /libbitnami.sh
. /libmysql.sh

eval "$(mysql_env)"

print_welcome_page

if [ "$*" = "/run.sh" ]; then
    info "** Starting MySQL setup **"
    /setup.sh
    info "** MySQL setup finished! **"
fi

echo ""
exec "$@"
