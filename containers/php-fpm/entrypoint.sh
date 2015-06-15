#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

print_welcome_page

if [ ! "$(ls -A $BITNAMI_APP_VOL_PREFIX/conf)" ]; then
  generate_conf_files $BITNAMI_APP_DIR/etc
fi

if [[ "$1" = 'php-fpm' ]]; then
  wait_and_tail_logs &
fi

exec "$@"
