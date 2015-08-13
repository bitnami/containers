# Tomcat Utility functions

initialize_tomcat_webapps() {
  echo "==> Initializing Tomcat webapps directory..."
  echo ""
  for f in $(ls $BITNAMI_APP_DIR/webapps.defaults/)
  do
    ln -sf $BITNAMI_APP_DIR/webapps.defaults/$f /app/
  done
}

print_tomcat_password() {
  if [ -z $TOMCAT_PASSWORD ]; then
    echo "**none**"
  else
    echo $TOMCAT_PASSWORD
  fi
}
