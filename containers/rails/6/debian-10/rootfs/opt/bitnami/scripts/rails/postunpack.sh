#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/librails.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Load Rails environment
eval "$(rails_env)"

info "Granting non-root permissions to /app directory"
mkdir -p /app
chown -R bitnami:bitnami /app
