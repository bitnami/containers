#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libsymfony.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libservice.sh

# Load Symfony environment
. /opt/bitnami/scripts/symfony-env.sh

cd /app

declare -a start_flags=("-S" "0.0.0.0:${SYMFONY_PORT_NUMBER}" "-t" "/app/public")
start_flags+=("$@")

info "** Starting Symfony project **"
php "${start_flags[@]}"
