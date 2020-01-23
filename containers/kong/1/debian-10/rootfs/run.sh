#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /liblog.sh
. /libos.sh
. /libkong.sh

# Load Kong environment variables
eval "$(kong_env)"

info "** Starting Kong **"

exec kong start
