#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

. /libbitnami.sh
. /libmariadb.sh

eval "$(mysql_env)"

print_welcome_page

if [ "$*" = "/run.sh" ]; then
    info "** Starting MariaDB setup **"
    /setup.sh
    info "** MariaDB setup finished! **"
fi

echo ""
exec "$@"
