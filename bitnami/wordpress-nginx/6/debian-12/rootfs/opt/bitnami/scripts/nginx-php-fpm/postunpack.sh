#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libnginx.sh
. /opt/bitnami/scripts/libvalidations.sh

# Load NGINX environment
. /opt/bitnami/scripts/nginx-env.sh
. /opt/bitnami/scripts/php-env.sh

# Write NGINX configuration
nginx_php_fpm_conf_file="${NGINX_CONF_DIR}/bitnami/php-fpm.conf"
fastcgi_pass="$PHP_FPM_DEFAULT_LISTEN_ADDRESS"
# Check if PHP_FPM_DEFAULT_LISTEN_ADDRESS refers to a socket file, and add the required prefix for NGINX to understand it
[[ "$fastcgi_pass" == "/"* ]] && fastcgi_pass="unix:$fastcgi_pass"
cat >"$nginx_php_fpm_conf_file" <<EOF
index index.html index.htm index.php;
location ~ \.php$ {
    fastcgi_read_timeout 300;
    fastcgi_pass   ${fastcgi_pass};
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME \$request_filename;
    include        fastcgi_params;
}
EOF
