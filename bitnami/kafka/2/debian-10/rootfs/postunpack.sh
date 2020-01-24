#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libkafka.sh
. /libfs.sh

# Load Kafka environment variables
eval "$(kafka_env)"

# Ensure directories used by Kafka exist and have proper ownership and permissions
for dir in "$KAFKA_LOGDIR" "$KAFKA_CONFDIR" "$KAFKA_VOLUMEDIR" "$KAFKA_DATADIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$KAFKA_BASEDIR" "$KAFKA_VOLUMEDIR" "$KAFKA_DATADIR"
