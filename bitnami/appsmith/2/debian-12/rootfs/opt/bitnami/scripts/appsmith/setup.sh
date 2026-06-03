#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libwebserver.sh
. /opt/bitnami/scripts/libappsmith.sh

# Load Appsmith environment settings
. /opt/bitnami/scripts/appsmith-env.sh

# Load web server environment (after WordPress environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure Appsmith environment settings are valid
appsmith_validate
# Ensure Appsmith is stopped when this script ends.
trap "appsmith_backend_stop" EXIT
# Ensure 'appsmith' user exists when running as 'root'
am_i_root && ensure_user_exists "$APPSMITH_DAEMON_USER" --group "$APPSMITH_DAEMON_GROUP"

debug "Copying files from $NGINX_DEFAULT_CONF_DIR to $NGINX_CONF_DIR"
cp -nr "$NGINX_DEFAULT_CONF_DIR"/. "$NGINX_CONF_DIR" || true

# Nginx configuration, based on upstream nginx configuration but removing hardcoded references to localhost
# https://github.com/appsmithorg/appsmith/blob/release/deploy/docker/templates/nginx/nginx-app-http.conf.template.sh#L102
ensure_web_server_app_configuration_exists "appsmith" \
    --document-root /opt/bitnami/appsmith/editor      \
    --http-port "$APPSMITH_UI_HTTP_PORT"              \
    --https-port "$APPSMITH_UI_HTTPS_PORT"            \
    --nginx-external-configuration $'
map $http_x_forwarded_proto $origin_scheme {
  default $http_x_forwarded_proto;
  \'\' $scheme;
}

map $http_x_forwarded_host $origin_host {
  default $http_x_forwarded_host;
  \'\' $host;
}
' \
    --nginx-additional-configuration "
client_max_body_size 100m;

gzip on;
gzip_types *;

server_tokens off;
index index.html index.htm;
error_page 404 /;

# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-ancestors
add_header Content-Security-Policy \"frame-ancestors 'self' *\";

proxy_set_header X-Forwarded-Proto \$origin_scheme;
proxy_set_header X-Forwarded-Host  \$origin_host;

location / {
  try_files \$uri /index.html =404;
}

location /api {
  proxy_set_header X-Forwarded-Proto \$scheme;
  proxy_set_header X-Forwarded-Host \$host;
  proxy_pass http://${APPSMITH_API_HOST}:${APPSMITH_API_PORT};
}

location /oauth2 {
  proxy_set_header X-Forwarded-Proto \$scheme;
  proxy_set_header X-Forwarded-Host \$host;
  proxy_pass http://${APPSMITH_API_HOST}:${APPSMITH_API_PORT};
}

location /login {
  proxy_set_header X-Forwarded-Proto \$scheme;
  proxy_set_header X-Forwarded-Host \$host;
  proxy_pass http://${APPSMITH_API_HOST}:${APPSMITH_API_PORT};
}

location /rts {
  proxy_pass http://${APPSMITH_RTS_HOST}:${APPSMITH_RTS_PORT};
  proxy_http_version 1.1;
  proxy_set_header Host \$host;
  proxy_set_header Connection 'upgrade';
  proxy_set_header Upgrade \$http_upgrade;
}
"

appsmith_initialize
