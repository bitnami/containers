# Wildfly Utility functions
PROGRAM_OPTIONS="-b 0.0.0.0 -bmanagement 0.0.0.0 \
  -Djboss.server.config.dir=$BITNAMI_APP_DIR/conf/standalone/configuration -Djboss.server.log.dir=$BITNAMI_APP_DIR/logs \
  -Djboss.domain.config.dir=$BITNAMI_APP_DIR/conf/domain/configuration -Djboss.domain.log.dir=$BITNAMI_APP_DIR/logs"
JAVA_OPTS="-XX:MaxPermSize=768m -Xmx768m $JAVA_OPTS"
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

print_wildfly_password() {
  if [ -z $WILDFLY_PASSWORD ]; then
    echo "wildfly"
  else
    echo $WILDFLY_PASSWORD
  fi
}
