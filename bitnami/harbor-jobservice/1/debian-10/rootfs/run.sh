#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh

readonly cmd=$(command -v harbor_jobservice)
readonly flags=("-c" "/etc/jobservice/config.yml" "$@")

info "** Starting Harbor Job Service **"
exec "${cmd}" "${flags[@]}"
