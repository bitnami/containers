#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh

readonly cmd=$(command -v registry)
readonly flags=("serve" "/etc/registry/config.yml" "$@")

info "** Starting Harbor Registry **"
exec "${cmd}" "${flags[@]}"
