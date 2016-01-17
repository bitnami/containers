# Wildfly Utility functions
PROGRAM_OPTIONS="-b 0.0.0.0 -bmanagement 0.0.0.0 \
  -Djboss.server.config.dir=$BITNAMI_APP_DIR/conf/standalone/configuration -Djboss.server.log.dir=$BITNAMI_APP_DIR/logs \
  -Djboss.domain.config.dir=$BITNAMI_APP_DIR/conf/domain/configuration -Djboss.domain.log.dir=$BITNAMI_APP_DIR/logs"
JAVA_OPTS="-XX:MaxPermSize=768m -Xmx768m $JAVA_OPTS"
export JAVA_OPTS

initialize_deployments_directory() {
  echo "==> Initializing deployments directory..."
  echo ""
  cp -a $BITNAMI_APP_DIR/standalone/deployments.defaults/* /app/
  touch /app/.initialized
}

print_wildfly_password() {
  if [ -z $WILDFLY_PASSWORD ]; then
    echo "wildfly"
  else
    echo $WILDFLY_PASSWORD
  fi
}
