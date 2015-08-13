# Tomcat Utility functions

initialize_tomcat_webapps() {
  echo "==> Initializing Tomcat webapps directory..."
  echo ""
  for f in $(ls $BITNAMI_APP_DIR/webapps.defaults/)
  do
    ln -sf $BITNAMI_APP_DIR/webapps.defaults/$f /app/
  done
}
