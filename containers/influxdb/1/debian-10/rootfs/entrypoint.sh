#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /liblog.sh
. /libbitnami.sh
. /libinfluxdb.sh

# Load InfluxDB environment variables
eval "$(influxdb_env)"

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting InfluxDB setup **"
    /setup.sh
    info "** InfluxDB setup finished! **"
fi

echo ""
exec "$@"
