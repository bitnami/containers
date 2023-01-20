#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libcassandra.sh

# Load Cassandra environment variables
. /opt/bitnami/scripts/cassandra-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/cassandra/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Cassandra setup **"
    /opt/bitnami/scripts/cassandra/setup.sh
    info "** Cassandra setup finished! **"
fi

echo ""
exec "$@"
