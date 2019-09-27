#!/bin/bash

_forwardTerm () {
    echo "Caugth signal SIGTERM, passing it to child processes..."
    pgrep -P $$ | xargs kill -15 2>/dev/null
    wait
    exit $?
}

trap _forwardTerm TERM

# Adding cron entries
# We need to remove them or the Matomo system check will fail
# There is no other element in the matomo conf folder
if [[ -d /opt/bitnami/matomo/conf/cron ]]; then
    mv /opt/bitnami/matomo/conf/cron /etc/cron.d/matomo
    rm -r /opt/bitnami/matomo/conf
fi

/usr/sbin/crond
echo "Starting Apache..."
exec httpd -f /opt/bitnami/apache/conf/httpd.conf -D FOREGROUND
