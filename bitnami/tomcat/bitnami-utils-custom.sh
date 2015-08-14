# Tomcat Utility functions

initialize_tomcat_webapps() {
  echo "==> Initializing Tomcat webapps directory..."
  echo ""
  cp -a $BITNAMI_APP_DIR/webapps.defaults/* /app/
}

print_tomcat_password() {
  if [ -z $TOMCAT_PASSWORD ]; then
    echo "**none**"
  else
    echo $TOMCAT_PASSWORD
  fi
}
