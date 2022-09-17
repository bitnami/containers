#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/liblogstash.sh

# Load Logstash environment variables
. /opt/bitnami/scripts/logstash-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/logstash/run.sh"* ]]; then
    info "** Starting Logstash setup **"
    /opt/bitnami/scripts/logstash/setup.sh
    info "** Logstash setup finished! **"
fi

echo ""
exec "$@"
