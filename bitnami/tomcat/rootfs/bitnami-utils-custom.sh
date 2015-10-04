# Tomcat Utility functions

initialize_tomcat_webapps_directory() {
  if [ ! -f /app/.initialized ]; then
    echo "==> Initializing Tomcat webapps directory..."
    echo ""
    cp -a $BITNAMI_APP_DIR/webapps.defaults/* /app/
    touch /app/.initialized
  else
    echo "==> Tomcat webapps directory already initialized..."
    echo ""
  fi
}

print_tomcat_password() {
  if [ -z $TOMCAT_PASSWORD ]; then
    echo "**none**"
  else
    echo $TOMCAT_PASSWORD
  fi
}
