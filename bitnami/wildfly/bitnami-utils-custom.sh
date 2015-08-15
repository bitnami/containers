# Wildfly Utility functions
PROGRAM_OPTIONS="-Dwildfly.as.deployment.ondemand=false -b 0.0.0.0 -bmanagement 0.0.0.0"
JAVA_OPTS="$JAVA_OPTS -XX:MaxPermSize=768m -Xmx768m"
export JAVA_OPTS

initialize_wildfly_deployments_directory() {
  if [ ! -f /app/.initialized ]; then
    echo "==> Initializing Wildfly deployments directory..."
    echo ""
    cp -a $BITNAMI_APP_DIR/standalone/deployments.defaults/* /app/
    touch /app/.initialized
  else
    echo "==> Wildfly deployments directory already initialized..."
    echo ""
  fi
}
