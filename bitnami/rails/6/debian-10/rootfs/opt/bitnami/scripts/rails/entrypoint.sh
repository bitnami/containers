#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/librails.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Rails environment
eval "$(rails_env)"

print_welcome_page

if [[ "$*" == "bundle exec "* ]]; then
    info "** Running Rails setup **"
    /opt/bitnami/scripts/rails/setup.sh
    info "** Rails setup finished! **"
fi

echo ""
exec "$@"
