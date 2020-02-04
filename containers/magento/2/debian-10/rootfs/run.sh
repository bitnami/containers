#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

_forwardTerm () {
    echo "Caught signal SIGTERM, passing it to child processes..."
    pgrep -P $$ | xargs kill -15 2>/dev/null
    wait
    exit $?
}

trap _forwardTerm TERM

# Adding cron entries
ln -sf /opt/bitnami/magento/conf/cron /etc/cron.d/magento

/usr/sbin/cron
echo "Starting Apache..."
exec httpd -f /opt/bitnami/apache/conf/httpd.conf -D FOREGROUND
