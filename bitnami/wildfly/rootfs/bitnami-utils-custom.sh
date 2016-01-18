# Wildfly Utility functions
PROGRAM_OPTIONS="-b 0.0.0.0 -bmanagement 0.0.0.0 \
  -Djboss.server.base.dir=$BITNAMI_APP_DIR/data/standalone \
  -Djboss.server.config.dir=$BITNAMI_APP_DIR/conf/standalone \
  -Djboss.server.log.dir=$BITNAMI_APP_DIR/logs \
  -Djboss.domain.base.dir=$BITNAMI_APP_DIR/data/domain \
  -Djboss.domain.config.dir=$BITNAMI_APP_DIR/conf/domain \
  -Djboss.domain.log.dir=$BITNAMI_APP_DIR/logs"

JAVA_OPTS="-XX:MaxPermSize=768m -Xmx768m $JAVA_OPTS"
export JAVA_OPTS

initialize_data_directory() {
  echo "==> Initializing deployments directory..."
  echo ""
  cp -a $BITNAMI_APP_DIR/data.defaults/* $BITNAMI_APP_DIR/data/
  touch $BITNAMI_APP_DIR/data/.initialized
}

set_manager_password() {
  if [ "$WILDFLY_PASSWORD" ]; then
    echo "Setting manager password..."
    echo ""
    add-user.sh -u manager -p $WILDFLY_PASSWORD -r ManagementRealm
  fi
}

print_wildfly_password() {
  if [ -z $WILDFLY_PASSWORD ]; then
    echo "wildfly"
  else
    echo $WILDFLY_PASSWORD
  fi
}
