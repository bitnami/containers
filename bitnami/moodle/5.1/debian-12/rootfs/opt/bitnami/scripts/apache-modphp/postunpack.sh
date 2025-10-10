#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libversion.sh
. /opt/bitnami/scripts/libapache.sh

# Load Apache environment
. /opt/bitnami/scripts/apache-env.sh
. /opt/bitnami/scripts/php-env.sh

# Enable required Apache modules
apache_enable_module "mpm_prefork_module"
php_version="$("${PHP_BIN_DIR}/php" -v | grep ^PHP | cut -d' ' -f2))"
php_major_version="$(get_sematic_version "$php_version" 1)"
if [[ "$php_major_version" -eq "8" ]]; then
    apache_enable_module "php_module" "modules/libphp.so"
else
    apache_enable_module "php${php_major_version}_module" "modules/libphp${php_major_version}.so"
fi

# Disable incompatible Apache modules
apache_disable_module "mpm_event_module"

# Write Apache configuration
apache_php_conf_file="${APACHE_CONF_DIR}/bitnami/php.conf"
cat > "$apache_php_conf_file" <<EOF
AddType application/x-httpd-php .php
DirectoryIndex index.html index.htm index.php
EOF
ensure_apache_configuration_exists "Include \"${apache_php_conf_file}\""

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "$APACHE_CONF_DIR"/* "$APACHE_DEFAULT_CONF_DIR"
