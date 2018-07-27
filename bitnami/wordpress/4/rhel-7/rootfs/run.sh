#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=httpd
EXEC=$(which $DAEMON)
ARGS="-f /opt/bitnami/apache/conf/httpd.conf -D FOREGROUND"

# create apache tmp directory
mkdir /opt/bitnami/apache/tmp

info "Starting ${DAEMON}..."
exec ${EXEC} ${ARGS}
