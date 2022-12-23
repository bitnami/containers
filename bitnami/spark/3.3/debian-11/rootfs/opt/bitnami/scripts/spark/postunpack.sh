#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libspark.sh

# Load Spark environment settings
. /opt/bitnami/scripts/spark-env.sh

for dir in "$SPARK_TMPDIR" "$SPARK_LOGDIR" "$SPARK_CONFDIR" "$SPARK_WORKDIR" "$SPARK_JARSDIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -g "root"
done
