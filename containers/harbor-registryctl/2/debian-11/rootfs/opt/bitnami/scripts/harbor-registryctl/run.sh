#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh

readonly cmd=$(command -v harbor_registryctl)
readonly flags=("-c" "/etc/registryctl/config.yml" "$@")

info "** Starting Harbor Registryctl **"
exec "${cmd}" "${flags[@]}"
