#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /libcassandra.sh

# Load Cassandra environment variables
eval "$(cassandra_env)"

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Cassandra setup **"
    /setup.sh
    info "** Cassandra setup finished! **"
fi

echo ""
exec "$@"
