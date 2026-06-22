#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libksql.sh
. /opt/bitnami/scripts/libfs.sh

# Load KSQL environment variables
. /opt/bitnami/scripts/ksql-env.sh

# Auxiliar functions

########################
# Create default config file
# Globals:
#   KSQL_CONF_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
ksql_create_default_config_file() {
    cat > "${KSQL_CONF_FILE}.default" << EOF
## The address(es) the socket server listens on.
##   FORMAT: listener_name://hostname:port
##
listeners = ${KSQL_DEFAULT_LISTENERS}

## The advertised address(es) the server is advertised on.
##   FORMAT: listener_name://hostname:port
##
# advertised.listener =

## Keystore & Trustore used to expose the REST API over HTTPS
##
ssl.client.authentication = NONE
# ssl.key.password =
# ssl.keystore.location =
# ssl.keystore.password =

## List of Kafka brokers to connect to.
##   FORMAT: broker_hostname:port
##
bootstrap.servers = ${KSQL_DEFAULT_BOOTSTRAP_SERVERS}

## Schema Registry server to connect to:
##   FORMAT: schema_registry_hostname:port
##
# ksql.schema.registry.url =

## Login configuration
##
ksql.logging.processing.topic.auto.create = true
ksql.logging.processing.stream.auto.create = true
ksql.logging.processing.rows.include = false

## Sets the storage directory for stateful operations
##
ksql.streams.state.dir = ${KSQL_DATA_DIR}
EOF
}

# Create default configuration file
rm "$KSQL_CONF_FILE"
ksql_create_default_config_file
# Ensure directories used by KSQL exist and have proper ownership and permissions
for dir in "$KSQL_CONF_DIR" "$KSQL_DATA_DIR" "$KSQL_LOGS_DIR" "$KSQL_CERTS_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done
