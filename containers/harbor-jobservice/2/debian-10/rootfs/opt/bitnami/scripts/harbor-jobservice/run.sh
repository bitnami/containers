#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh

readonly cmd=$(command -v harbor_jobservice)
readonly flags=("-c" "/etc/jobservice/config.yml" "$@")

info "** Starting Harbor Job Service **"
exec "${cmd}" "${flags[@]}"
