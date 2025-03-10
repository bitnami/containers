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

# Load PHP-FPM environment variables
. /opt/bitnami/scripts/php-env.sh

# PHP OPcache optimizations
php_conf_set "opcache.interned_strings_buffer" "$PHP_DEFAULT_OPCACHE_INTERNED_STRINGS_BUFFER"
php_conf_set "opcache.memory_consumption" "$PHP_DEFAULT_OPCACHE_MEMORY_CONSUMPTION"
php_conf_set "opcache.file_cache" "$PHP_DEFAULT_OPCACHE_FILE_CACHE"

# PHP-FPM configuration
php_conf_set "listen" "$PHP_FPM_DEFAULT_LISTEN_ADDRESS" "${PHP_CONF_DIR}/php-fpm.d/www.conf"

# TMP dir configuration
php_conf_set "upload_tmp_dir" "${PHP_BASE_DIR}/tmp"
php_conf_set "session.save_path" "${PHP_TMP_DIR}/session"

# Ensure directories used by PHP-FPM exist and have proper ownership and permissions
for dir in "$PHP_CONF_DIR" "$PHP_DEFAULT_CONF_DIR" "${PHP_BASE_DIR}/tmp" "$PHP_TMP_DIR" "$PHP_FPM_LOGS_DIR" "${PHP_TMP_DIR}/session"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

info "Disabling PHP-FPM daemon user/group configuration"
mv "${PHP_CONF_DIR}/common.conf" "${PHP_CONF_DIR}/common.conf.disabled"
touch "${PHP_CONF_DIR}/common.conf"

# Log to stdout/stderr for easy debugging
ln -sf "/dev/stdout" "$PHP_FPM_LOG_FILE"
php_conf_set "error_log" "/dev/stderr"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "$PHP_CONF_DIR"/* "$PHP_DEFAULT_CONF_DIR"
