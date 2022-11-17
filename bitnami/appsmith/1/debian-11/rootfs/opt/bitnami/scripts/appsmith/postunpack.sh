#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libappsmith.sh

# Load Appsmith environment variables
. /opt/bitnami/scripts/appsmith-env.sh

# System User
ensure_user_exists "$APPSMITH_DAEMON_USER" --group "$APPSMITH_DAEMON_GROUP" --system

for dir in "${APPSMITH_CONF_DIR}" "${APPSMITH_LOG_DIR}" "${APPSMITH_TMP_DIR}" "${APPSMITH_VOLUME_DIR}"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -g "root"
done

# Generate default configuration file
# https://github.com/appsmithorg/appsmith/blob/release/deploy/docker/templates/docker.env.sh#L14
bash "${APPSMITH_BASE_DIR}/templates/docker.env.sh" "" "" "" "" "" >"${APPSMITH_CONF_FILE}"
chmod -R g+rwX "${APPSMITH_CONF_FILE}"

# Nginx configuration. Adapted from upstream nginx configuration but removing hardcoded
# references to localhost
# https://github.com/appsmithorg/appsmith/blob/release/deploy/docker/templates/nginx/nginx-app-http.conf.template.sh#L102
cat <<"EOF" >"${APPSMITH_BASE_DIR}/conf/nginx-app-http.conf.template"
map $http_x_forwarded_proto $origin_scheme {
  default $http_x_forwarded_proto;
  '' $scheme;
}

map $http_x_forwarded_host $origin_host {
  default $http_x_forwarded_host;
  '' $host;
}
server {
    listen {{APPSMITH_UI_HTTP_PORT}};

    client_max_body_size 100m;

    gzip on;
    gzip_types *;

    server_tokens off;
    root /opt/bitnami/appsmith/editor;
    index index.html index.htm;
    error_page 404 /;

    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-ancestors
    add_header Content-Security-Policy "frame-ancestors 'self' *";

    proxy_set_header X-Forwarded-Proto $origin_scheme;
    proxy_set_header X-Forwarded-Host  $origin_host;

    location / {
        try_files $uri /index.html =404;
    }

    location /api {
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_pass http://{{APPSMITH_API_HOST}}:{{APPSMITH_API_PORT}};
    }

    location /oauth2 {
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_pass http://{{APPSMITH_API_HOST}}:{{APPSMITH_API_PORT}};
    }

    location /login {
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_pass http://{{APPSMITH_API_HOST}}:{{APPSMITH_API_PORT}};
    }

    location /rts {
      proxy_pass http://{{APPSMITH_RTS_HOST}}:{{APPSMITH_RTS_PORT}};
      proxy_http_version 1.1;
      proxy_set_header Host $host;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Upgrade $http_upgrade;
    }
}
EOF

# Add symlinks to the default paths to make a similar UX as the upstream Appsmith container
# https://github.com/appsmithorg/appsmith/blob/release/Dockerfile#L6
ln -s "${APPSMITH_BASE_DIR}" "/opt/appsmith"
