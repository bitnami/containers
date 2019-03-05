#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libnginx.sh

# Load NGINX environment variables
eval "$(nginx_env)"

for dir in "/bitnami" "$NGINX_VOLUME" "$NGINX_CONFDIR" "$NGINX_BASEDIR" "$NGINX_TMPDIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Users can mount their html sites at /app
ln -sf "$NGINX_BASEDIR/html" /app
# Redirect all logging to stdout/stderr
ln -sf /dev/stdout "$NGINX_LOGDIR/access.log"
ln -sf /dev/stderr "$NGINX_LOGDIR/error.log"
