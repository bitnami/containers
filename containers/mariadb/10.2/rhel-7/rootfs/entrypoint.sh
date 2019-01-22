#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /libmariadb.sh

# Load MariaDB env. variables
eval "$(mysql_env)"

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting MariaDB setup **"
    /setup.sh
    info "** MariaDB setup finished! **"
fi

echo ""
exec "$@"
