#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libspark.sh

# Load Spark environment variables
eval "$(spark_env)"

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
  *)
    # Non-spark-on-k8s command provided, proceeding in pass-through mode
    CMD=("$@")
    ;;
esac

echo ""
exec "${CMD[@]}"
