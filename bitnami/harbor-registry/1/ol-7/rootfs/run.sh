#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh

readonly cmd=$(command -v registry)
readonly flags=("serve" "/etc/registry/config.yml" "$@")

info "** Starting Harbor Registry **"
exec "${cmd}" "${flags[@]}"
