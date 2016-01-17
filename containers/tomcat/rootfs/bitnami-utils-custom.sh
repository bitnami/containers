# Tomcat Utility functions

initialize_webapps_directory() {
  echo "==> Initializing webapps directory..."
  echo ""
  cp -a $BITNAMI_APP_DIR/webapps.defaults/* /app/
  touch /app/.initialized
}

print_tomcat_password() {
  if [ -z $TOMCAT_PASSWORD ]; then
    echo "**none**"
  else
    echo $TOMCAT_PASSWORD
  fi
}
