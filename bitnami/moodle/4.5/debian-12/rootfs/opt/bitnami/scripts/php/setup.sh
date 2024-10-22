#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load PHP-FPM environment variables
. /opt/bitnami/scripts/php-env.sh

# Ensure PHP-FPM daemon user exists and required folder belongs to this user when running as 'root'
if am_i_root; then
    ensure_user_exists "$PHP_FPM_DAEMON_USER" --group "$PHP_FPM_DAEMON_GROUP"
    ensure_dir_exists "$PHP_TMP_DIR"
    chown -R "${PHP_FPM_DAEMON_USER}:${PHP_FPM_DAEMON_GROUP}" "$PHP_TMP_DIR"
    # Enable daemon configuration
    if [[ ! -f "${PHP_CONF_DIR}/common.conf" ]]; then
        cp "${PHP_CONF_DIR}/common.conf.disabled" "${PHP_CONF_DIR}/common.conf"
    fi
fi

php_initialize

# Fix logging issue when running as root
! am_i_root || chmod o+w "$(readlink /dev/stdout)" "$(readlink /dev/stderr)"
