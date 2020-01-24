#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /libbitnami.sh
. /liblog.sh
. /liblogstash.sh

# Load Logstash environment variables
eval "$(logstash_env)"

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Logstash setup **"
    /setup.sh
    info "** Logstash setup finished! **"
fi

echo ""
exec "$@"
