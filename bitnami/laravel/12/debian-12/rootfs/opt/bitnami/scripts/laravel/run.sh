#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblaravel.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libservice.sh

# Load Laravel environment
. /opt/bitnami/scripts/laravel-env.sh

cd /app

declare -a start_flags=("artisan" "serve" "--host=0.0.0.0" "--port=${LARAVEL_PORT_NUMBER}")
start_flags+=("$@")

info "** Starting Laravel project **"
php "${start_flags[@]}"
