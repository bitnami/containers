#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Parse environment
. /opt/bitnami/scripts/parse-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/parse/run.sh" ]]; then
    /opt/bitnami/scripts/parse/setup.sh
    /post-init.sh
    info "** Parse setup finished! **"
fi

echo ""
exec "$@"
