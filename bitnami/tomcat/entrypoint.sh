#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

print_welcome_page

# if command starts with an option, prepend 'catalina.sh run'
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS="$@"
  set -- catalina.sh run
fi

if [ ! "$(ls -A $BITNAMI_APP_VOL_PREFIX/conf)" ]; then
  generate_conf_files

  if [ "$TOMCAT_PASSWORD" ]; then
    echo ""
    echo "Setting manager password in tomcat-users.xml ..."
    sed -i 's/username="manager" password=""/username="manager" password="'"$TOMCAT_PASSWORD"'"/' $BITNAMI_APP_VOL_PREFIX/conf/tomcat-users.xml
    print_app_credentials $BITNAMI_APP_NAME manager $TOMCAT_PASSWORD
  fi
else
  print_container_already_initialized $BITNAMI_APP_NAME
fi

chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_APP_VOL_PREFIX/conf/ $BITNAMI_APP_VOL_PREFIX/logs/ $BITNAMI_APP_VOL_PREFIX/webapps/ || true

if [ "$1" = 'catalina.sh' ]; then
  set -- $@ $EXTRA_OPTIONS

  if [ ! -d $BITNAMI_APP_VOL_PREFIX/webapps/manager ]; then
    initialize_tomcat_webapps
  fi

  exec gosu $BITNAMI_APP_USER "$@"
else
  exec "$@"
fi

