#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh

readonly cmd=$(command -v harbor-adapter-clair)

info "** Starting Harbor Adapter Clair **"
exec "${cmd}"
