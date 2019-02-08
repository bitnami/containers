#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

# Adding cron entries
ln -fs /opt/bitnami/moodle/conf/cron /etc/cron.d/moodle

/usr/sbin/crond
DAEMON=httpd
EXEC=$(which $DAEMON)
ARGS="-f /opt/bitnami/apache/conf/httpd.conf -D FOREGROUND"

info "Starting ${DAEMON}..."
${EXEC} ${ARGS}
