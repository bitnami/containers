#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /libspark.sh

# Load Spark environment variables
eval "$(spark_env)"

for dir in "$SPARK_TMPDIR" "$SPARK_LOGDIR" "$SPARK_CONFDIR" "$SPARK_WORKDIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$SPARK_LOGDIR" "$SPARK_TMPDIR" "$SPARK_CONFDIR" "$SPARK_WORKDIR"
