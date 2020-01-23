#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /libbitnami.sh
. /liblog.sh
. /libkong.sh

eval "$(kong_env)"

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Kong setup **"
    /setup.sh
    info "** Kong setup finished! **"
fi

echo ""
exec "$@"
