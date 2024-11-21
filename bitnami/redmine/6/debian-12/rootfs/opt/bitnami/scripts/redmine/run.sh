#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redmine environment
. /opt/bitnami/scripts/redmine-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libredmine.sh

cd "$REDMINE_BASE_DIR"

declare -a cmd=(
    "bundle" "exec" "passenger" "start"
    "--user" "$REDMINE_DAEMON_USER"
    "-e" "$REDMINE_ENV"
    "-p" "$REDMINE_PORT_NUMBER"
)

info "** Starting Redmine **"
exec "${cmd[@]}" "$@"
