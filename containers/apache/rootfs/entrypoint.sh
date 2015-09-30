#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

print_welcome_page
generate_conf_files

if [ ! "$(ls -A /app)" ]; then
  cp -r $BITNAMI_APP_DIR/htdocs.defaults/* $BITNAMI_APP_DIR/htdocs
fi

# Remove zombie pidfile
rm -f $BITNAMI_APP_DIR/logs/httpd.pid

if [[ "$@" = 'httpd' ]]; then
  exec $@ -DFOREGROUND -f $BITNAMI_APP_DIR/conf/httpd.conf
else
  exec "$@"
fi

