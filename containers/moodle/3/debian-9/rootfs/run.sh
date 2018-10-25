#!/bin/bash

# Adding cron entries
ln -fs /opt/bitnami/moodle/conf/cron /etc/cron.d/moodle

/usr/sbin/cron
DAEMON=httpd
EXEC=$(which $DAEMON)
ARGS="-f /opt/bitnami/apache/conf/httpd.conf -D FOREGROUND"

info "Starting ${DAEMON}..."
${EXEC} ${ARGS}
