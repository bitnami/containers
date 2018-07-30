#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=httpd
EXEC=$(which $DAEMON)
ARGS="-f /opt/bitnami/apache/conf/httpd.conf -D FOREGROUND"

# redirect apache logs to stdout/stderr
ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
ln -sf /dev/stdout /opt/bitnami/apache/logs/error_log

# create apache tmp directory
mkdir /opt/bitnami/apache/tmp

info "Starting ${DAEMON}..."
exec ${EXEC} ${ARGS}
