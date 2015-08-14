# Wildfly Utility functions
PROGRAM_OPTIONS="-Dwildfly.as.deployment.ondemand=false -b 0.0.0.0 -bmanagement 0.0.0.0"
JAVA_OPTS="$JAVA_OPTS -XX:MaxPermSize=768m -Xmx768m"
export JAVA_OPTS

initialize_wildfly_deployments_directory() {
  echo "==> Initializing Wildfly deployments directory..."
  echo ""
  for f in $(ls $BITNAMI_APP_DIR/standalone/deployments.defaults/)
  do
    ln -sf $BITNAMI_APP_DIR/standalone/deployments.defaults/$f /app/
  done
}
