#!/bin/bash

. /libnginx.sh
eval "$(nginx_env)"

# TODO: This is super annoying, with all the "non root" thing with all privileges
# Volume must be world writable so container's user has full access.
for dir in /bitnami "$NGINX_VOLUME" "$NGINX_CONFDIR" "$NGINX_BASEDIR" "$NGINX_TMPDIR"; do
    mkdir -p "$dir"
    chmod -R g+rwX "$dir"
done

ln -sf "$NGINX_BASEDIR/html" /app
ln -sf /dev/stdout "$NGINX_LOGDIR/access.log"
ln -sf /dev/stderr "$NGINX_LOGDIR/error.log"

