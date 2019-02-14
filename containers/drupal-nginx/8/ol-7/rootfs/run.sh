#!/bin/bash

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

NGINX_INSTALLDIR="/opt/bitnami/nginx"
NGINX_CONF_DIR="${NGINX_INSTALLDIR}/conf"
PHP_INSTALLDIR="/opt/bitnami/php"
PHP_CONF_DIR="${PHP_INSTALLDIR}/etc"
PHP_TEMP_DIR="${PHP_INSTALLDIR}/tmp"

_forwardTerm () {
 echo "Caugth signal SIGTERM, passing it to child processes..."
 cpids=$(pgrep -P $$ | xargs)
 kill -15 "$cpids" 2> /dev/null
 wait
 exit $?
}

trap _forwardTerm TERM

info "Starting php-fpm..."
su daemon -s /bin/bash -c "${PHP_INSTALLDIR}/sbin/php-fpm --pid ${PHP_TEMP_DIR}/php5-fpm.pid --fpm-config ${PHP_CONF_DIR}/php-fpm.conf --prefix ${PHP_INSTALLDIR} -c ${PHP_CONF_DIR}/php.ini" &

info "Starting nginx..."
nginx -c "${NGINX_CONF_DIR}/nginx.conf" -g "daemon off;"
