#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=php-fpm
EXEC=$(which $DAEMON)
ARGS="-F --pid /opt/bitnami/php/tmp/php5-fpm.pid --fpm-config /opt/bitnami/php/etc/php-fpm.conf --prefix /opt/bitnami/php -c /opt/bitnami/php/etc/php.ini"

if [ -f composer.json  ]; then
  composer install
fi

chown -R :daemon /bitnami/php || true

# redirect php logs to stdout
ln -sf /dev/stdout /opt/bitnami/php/logs/php-fpm.log

info "Starting ${DAEMON}..."
exec ${EXEC} ${ARGS}
