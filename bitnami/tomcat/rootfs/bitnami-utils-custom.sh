# Tomcat Utility functions

initialize_webapps_directory() {
  echo "==> Initializing webapps directory..."
  echo ""
  cp -a $BITNAMI_APP_DIR/webapps.defaults/* /app/
  touch /app/.initialized
}

set_manager_password() {
  if [ "$TOMCAT_PASSWORD" ]; then
    echo ""
    echo "==> Setting manager password..."
    sed -i "s/^\(<user username=\"manager\" password=\"\)\([^ \"]*\)\(\".*\)/\1$TOMCAT_PASSWORD\3/" $BITNAMI_APP_VOL_PREFIX/conf/tomcat-users.xml
  fi
}

print_tomcat_password() {
  if [ -z $TOMCAT_PASSWORD ]; then
    echo "**none**"
  else
    echo $TOMCAT_PASSWORD
  fi
}
