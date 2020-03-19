#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libkong.sh

eval "$(kong_env)"

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/kong/run.sh"* ]]; then
    info "** Starting Kong setup **"
    /opt/bitnami/scripts/kong/setup.sh
    info "** Kong setup finished! **"
fi

echo ""
exec "$@"
