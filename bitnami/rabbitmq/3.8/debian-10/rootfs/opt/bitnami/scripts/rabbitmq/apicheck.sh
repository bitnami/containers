#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libos.sh

URL=$1
EXPECTED=$2
ACTUAL=$(curl --silent --show-error --fail "$URL")
info "Actual response: ${ACTUAL}"
info "Expected response: ${EXPECTED}"
test "$EXPECTED" = "$ACTUAL"
