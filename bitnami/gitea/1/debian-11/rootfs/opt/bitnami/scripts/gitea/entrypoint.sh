#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Gitea environment variables
. /opt/bitnami/scripts/gitea-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/gitea/run.sh" ]]; then
    info "** Starting Gitea setup **"
    /opt/bitnami/scripts/gitea/setup.sh
    info "** Gitea setup finished! **"
fi

echo ""
exec "$@"
