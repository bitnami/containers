#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=nginx
EXEC=$(which $DAEMON)
ARGS=

chown -R :daemon /opt/bitnami/nginx/html || true

# redirect nginx logs to stdout/stderr
ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log

info "Starting ${DAEMON}..."
exec ${EXEC} ${ARGS} -g 'daemon off;'
