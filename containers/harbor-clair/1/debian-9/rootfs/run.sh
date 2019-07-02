#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh

readonly cmd=$(command -v clair)
readonly flags=("-config" "/etc/clair/config.yaml" "$@")

info "** Starting Harbor Clair **"
exec "${cmd}" "${flags[@]}"