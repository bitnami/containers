#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libspark.sh

# Load Spark environment settings
. /opt/bitnami/scripts/spark-env.sh

print_welcome_page

if [ ! $EUID -eq 0 ] && [ -e "$LIBNSS_WRAPPER_PATH" ]; then
    echo "spark:x:$(id -u):$(id -g):Spark:$SPARK_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "spark:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
    echo "LD_PRELOAD=$LIBNSS_WRAPPER_PATH" >> "$SPARK_CONFDIR/spark-env.sh"
fi

if [[ "$1" = "/opt/bitnami/scripts/spark/run.sh" ]]; then
    info "** Starting Spark setup **"
    /opt/bitnami/scripts/spark/setup.sh
    info "** Spark setup finished! **"
fi

# Spark has an special 'driver' command which is an alias for spark-submit
# https://github.com/apache/spark/blob/master/resource-managers/kubernetes/docker/src/main/dockerfiles/spark/entrypoint.sh
case "$1" in
  driver)
    shift 1
    CMD=(
        "/opt/bitnami/spark/bin/spark-submit"
        --master "${SPARK_MASTER_URL}"
        --conf "spark.jars.ivy=/tmp/.ivy"
        --deploy-mode client
        "$@"
    )
    ;;
  executor)
    shift 1

    set +o pipefail

    env | grep SPARK_JAVA_OPT_ | sort -t_ -k4 -n | sed 's/[^=]*=\(.*\)/\1/g' > /tmp/java_opts.txt
    readarray -t SPARK_EXECUTOR_JAVA_OPTS < /tmp/java_opts.txt

    set -o pipefail

    CMD=(
      ${JAVA_HOME}/bin/java
      "${SPARK_EXECUTOR_JAVA_OPTS[@]}"
      -Xms$SPARK_EXECUTOR_MEMORY
      -Xmx$SPARK_EXECUTOR_MEMORY
      -cp '/opt/bitnami/spark/conf::/opt/bitnami/spark/jars/*'
      org.apache.spark.scheduler.cluster.k8s.KubernetesExecutorBackend
      --driver-url $SPARK_DRIVER_URL
      --executor-id $SPARK_EXECUTOR_ID
      --cores $SPARK_EXECUTOR_CORES
      --app-id $SPARK_APPLICATION_ID
      --hostname $SPARK_EXECUTOR_POD_IP
      --resourceProfileId $SPARK_RESOURCE_PROFILE_ID
      --podName $SPARK_EXECUTOR_POD_NAME
    )
    ;;

  *)
    # Non-spark-on-k8s command provided, proceeding in pass-through mode
    CMD=("$@")
    ;;
esac

echo ""
exec "${CMD[@]}"
