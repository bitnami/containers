#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libcodeigniter.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libservice.sh

# Load CodeIgniter environment
. /opt/bitnami/scripts/codeigniter-env.sh

PROJECT_DIR="/app${CODEIGNITER_PROJECT_NAME:+"/${CODEIGNITER_PROJECT_NAME}"}"

cd "$PROJECT_DIR"

declare -a start_flags=("-S" "0.0.0.0:${CODEIGNITER_PORT_NUMBER}" "-t" "${PROJECT_DIR}/public")
start_flags+=("$@")

info "** Starting CodeIgniter project **"
php "${start_flags[@]}"
