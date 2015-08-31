#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

print_welcome_page

# if command starts with an option, prepend 'standalone.sh'
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS="$@"
  set -- standalone.sh
fi

if [ ! "$(ls -A $BITNAMI_APP_VOL_PREFIX/conf)" ]; then
  generate_conf_files $BITNAMI_APP_DIR/standalone/

  if [ "$WILDFLY_PASSWORD" ]; then
    echo ""
    echo "Setting manager password..."
    add-user.sh -u manager -p $WILDFLY_PASSWORD -r ManagementRealm
  fi
  print_app_credentials $BITNAMI_APP_NAME manager `print_wildfly_password`
else
  print_container_already_initialized $BITNAMI_APP_NAME
fi

chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_APP_VOL_PREFIX/conf/ $BITNAMI_APP_VOL_PREFIX/logs/ /app/ || true

if [ "$1" = 'standalone.sh' ]; then
  set -- $@ $PROGRAM_OPTIONS $EXTRA_OPTIONS

  initialize_wildfly_deployments_directory

  exec gosu $BITNAMI_APP_USER "$@"
else
  exec "$@"
fi
