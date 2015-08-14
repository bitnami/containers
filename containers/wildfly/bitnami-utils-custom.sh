# Wildfly Utility functions
PROGRAM_OPTIONS="-Dwildfly.as.deployment.ondemand=false -b 0.0.0.0 -bmanagement 0.0.0.0"
JAVA_OPTS="$JAVA_OPTS -XX:MaxPermSize=768m -Xmx768m"
export JAVA_OPTS
