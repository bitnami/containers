#!/bin/bash

if [ ! "$(ls -A /conf)" ]; then
  cp -r /usr/local/bitnami/apache2/conf.defaults/* /usr/local/bitnami/apache2/conf
fi

if [ ! "$(ls -A /app)" ]; then
  cp -r /usr/local/bitnami/apache2/htdocs.defaults/* /usr/local/bitnami/apache2/htdocs
fi

# Remove zombie pidfile
rm -f /usr/local/bitnami/apache2/logs/httpd.pid

exec "$@"
