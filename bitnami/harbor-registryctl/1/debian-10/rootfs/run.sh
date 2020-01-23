#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh

readonly cmd=$(command -v harbor_registryctl)
readonly flags=("-c" "/etc/registryctl/config.yml" "$@")

info "** Starting Harbor Registryctl **"
exec "${cmd}" "${flags[@]}"
