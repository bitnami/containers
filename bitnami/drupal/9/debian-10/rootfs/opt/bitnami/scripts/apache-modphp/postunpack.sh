#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libapache.sh

# Load Apache environment
. /opt/bitnami/scripts/apache-env.sh
. /opt/bitnami/scripts/php-env.sh

# Enable required Apache modules
apache_enable_module "mpm_prefork_module"
apache_enable_module "php7_module" "modules/libphp7.so"

# Disable incompatible Apache modules
apache_disable_module "mpm_event_module"

# Write Apache configuration
apache_php_conf_file="${APACHE_CONF_DIR}/bitnami/php.conf"
cat > "$apache_php_conf_file" <<EOF
AddType application/x-httpd-php .php
DirectoryIndex index.html index.htm index.php
EOF
ensure_apache_configuration_exists "Include \"${apache_php_conf_file}\""
