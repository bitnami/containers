#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /libtomcat.sh
. /liblog.sh

# Load Tomcat environment variables
eval "$(tomcat_env)"

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting tomcat setup **"
    /setup.sh
    info "** tomcat setup finished! **"
fi

echo ""
exec "$@"
