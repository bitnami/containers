#!/bin/bash
#
# Bitnami Pgpool healthcheck

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# shellcheck disable=SC1091

# Load libraries
. /libpgpool.sh

# Load Pgpool env. variables
eval "$(pgpool_env)"

pgpool_healthcheck
