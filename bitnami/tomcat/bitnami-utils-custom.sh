# Tomcat Utility functions

initialize_tomcat_webapps() {
  echo "==> Initializing Tomcat webapps..."
  echo ""
  cp -a $BITNAMI_APP_DIR/webapps.defaults/* $BITNAMI_APP_DIR/webapps/
}
