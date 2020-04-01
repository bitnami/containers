#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libkafka.sh
. /opt/bitnami/scripts/libfs.sh

# Load Kafka environment variables
eval "$(kafka_env)"

# Move server.properties from configtmp to config.
# Temporary solution until kafka tarball places server.properties into config.
mv "$KAFKA_BASEDIR"/configtmp/* "$KAFKA_CONFDIR"
rmdir "$KAFKA_BASEDIR"/configtmp

# Ensure directories used by Kafka exist and have proper ownership and permissions
for dir in "$KAFKA_LOGDIR" "$KAFKA_CONFDIR" "$KAFKA_MOUNTED_CONFDIR" "$KAFKA_VOLUMEDIR" "$KAFKA_DATADIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$KAFKA_BASEDIR" "$KAFKA_VOLUMEDIR" "$KAFKA_DATADIR"
