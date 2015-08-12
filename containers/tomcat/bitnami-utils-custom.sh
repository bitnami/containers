# Tomcat Utility functions

initialize_tomcat_webapps() {
  echo "==> Initializing Tomcat webapps directory..."
  echo ""
  cp -a $BITNAMI_APP_DIR/webapps.defaults/* /app/
}
