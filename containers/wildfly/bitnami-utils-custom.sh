# Wildfly Utility functions
PROGRAM_OPTIONS="-Djboss.server.config.dir=$BITNAMI_APP_DIR/standalone/conf -Djboss.server.log.dir=$BITNAMI_APP_DIR/standalone/logs -Dwildfly.as.deployment.ondemand=false -b 0.0.0.0 -bmanagement 0.0.0.0"
JAVA_OPTS="$JAVA_OPTS -XX:MaxPermSize=768m -Xmx768m"
export JAVA_OPTS
