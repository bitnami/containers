#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /libfluentd.sh
. /libbitnami.sh

# Load Fluentd environment
eval "$(fluentd_env)"

print_welcome_page

if [[ "$*" == *"/run.sh"* ]]; then
    info "** Starting Fluentd setup **"
    /setup.sh
    info "** Fluentd setup finished! **"
fi

echo ""
exec "$@"
