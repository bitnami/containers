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

if [ ! $EUID -eq 0 ] && [ -e /usr/lib/libnss_wrapper.so ]; then
    echo "spark:x:$(id -u):$(id -g):Spark:$SPARK_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "spark:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
    echo "LD_PRELOAD=/usr/lib/libnss_wrapper.so" >> "$SPARK_CONFDIR/spark-env.sh"
fi

if [[ "$*" = "/opt/bitnami/scripts/spark/run.sh" ]]; then
    info "** Starting Spark setup **"
    /opt/bitnami/scripts/spark/setup.sh
    info "** Spark setup finished! **"
fi

echo ""
exec "$@"
