#!/bin/bash

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

_forwardTerm () {
    echo "Caugth signal SIGTERM, passing it to child processes..."
    pgrep -P $$ | xargs kill -15 2>/dev/null
    wait
    exit $?
}

trap _forwardTerm TERM

info "Starting PHP-FPM..."
su daemon -s /bin/bash -c "/opt/bitnami/php/sbin/php-fpm -F --pid /opt/bitnami/php/tmp/php-fpm.pid --fpm-config /opt/bitnami/php/etc/php-fpm.conf --prefix /opt/bitnami/php -c /opt/bitnami/php/etc/php.ini" &

info "Starting NGINX..."
exec nginx -c /opt/bitnami/nginx/conf/nginx.conf -g "daemon off;"
