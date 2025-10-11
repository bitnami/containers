#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Moodle environment
. /opt/bitnami/scripts/moodle-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libwebserver.sh

# Catch SIGTERM signal and stop all child processes
_forwardTerm() {
    warn "Caught signal SIGTERM, passing it to child processes..."
    pgrep -P $$ | xargs kill -TERM 2>/dev/null
    wait
    exit $?
}
trap _forwardTerm TERM

# Start cron
if am_i_root; then
    info "** Starting cron **"
    if ! cron_start; then
        error "Failed to start cron. Check that it is installed and its configuration is correct."
        exit 1
    fi
else
    warn "Cron will not be started because of running as a non-root user"
fi

# Start Apache
if [[ -f "/opt/bitnami/scripts/nginx-php-fpm/run.sh" ]]; then
    exec "/opt/bitnami/scripts/nginx-php-fpm/run.sh"
else
    exec "/opt/bitnami/scripts/$(web_server_type)/run.sh"
fi
