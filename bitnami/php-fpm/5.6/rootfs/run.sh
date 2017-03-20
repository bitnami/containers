#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=php-fpm
EXEC=$(which $DAEMON)
ARGS="-F"

info "Starting ${DAEMON}..."
exec ${EXEC} ${ARGS}
