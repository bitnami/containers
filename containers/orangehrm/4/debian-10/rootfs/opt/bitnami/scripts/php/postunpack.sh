#!/bin/bash

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
php_conf_set upload_tmp_dir "$PHP_TMP_DIR"

# Ensure directories used by PHP-FPM exist and have proper ownership and permissions
for dir in "$PHP_CONF_DIR" "$PHP_TMP_DIR" "$PHP_FPM_LOGS_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

info "Disabling PHP-FPM daemon user/group configuration"
mv "${PHP_CONF_DIR}/common.conf" "${PHP_CONF_DIR}/common.conf.disabled"
touch "${PHP_CONF_DIR}/common.conf"

ln -sf "/dev/stdout" "${PHP_FPM_LOG_FILE}"
