#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libschemaregistry.sh
. /opt/bitnami/scripts/libfs.sh

# Load Schema Registry environment variables
. /opt/bitnami/scripts/schema-registry-env.sh

# Functions

########################
# Sets up the default configuration file
# Globals:
#   SCHEMA_REGISTRY_*
# Arguments:
#   None
# Returns:
#   None
#########################
schema_registry_create_default_configuration() {
    cat > "${SCHEMA_REGISTRY_CONF_DIR}/schema-registry/schema-registry.properties.default" << EOF
## The address the socket server listens on.
##   FORMAT: listener_name://hostname:port
##
listeners = ${SCHEMA_REGISTRY_DEFAULT_LISTENERS}

## List of Kafka brokers to connect to.
##   FORMAT: protocol://broker_hostname:port
##
kafkastore.bootstrap.servers = ${SCHEMA_REGISTRY_DEFAULT_KAFKA_BROKERS}

## The hostname advertised in ZooKeeper
##
# host.name =

## The durable single partition topic that acts as the durable log for the data.
##
kafkastore.topic = _schemas

## The desired replication factor of the schema topic
##
kafkastore.topic.replication.factor = 3

## The security protocol to use when connecting with Kafka
##
kafkastore.security.protocol = PLAINTEXT

## The SASL mechanism used for Kafka connections
##
kafkastore.sasl.mechanism = PLAIN
# kafkastore.sasl.jaas.config =

## Keystore & Trustore used for TLS communication with Kafka brokers
##
# kafkastore.ssl.key.password =
# kafkastore.ssl.keystore.location =
# kafkastore.ssl.keystore.password =
# kafkastore.ssl.truststore.location =
# kafkastore.ssl.truststore.password =
kafkastore.ssl.endpoint.identification.algorithm =

## Keystore & Trustore used to expose the REST API over HTTPS
##
ssl.client.authentication = NONE
# ssl.key.password =
# ssl.keystore.location =
# ssl.keystore.password =
## The truststore is required only when ssl.client.auth is set to true
# ssl.truststore.location =
# ssl.truststore.password =

## The protocol used while making calls between the instances of Schema Registry
##
inter.instance.protocol = http

## The Schema compatibility type
##
schema.compatibility.level = backward

## Enable debug logs
##
debug = false
EOF
}

# Create Default configuration
rm "$SCHEMA_REGISTRY_CONF_FILE"
schema_registry_create_default_configuration
# Ensure directories used by Schema Registry exist and have proper ownership and permissions
for dir in "$SCHEMA_REGISTRY_CONF_DIR" "$SCHEMA_REGISTRY_DEFAULT_CONF_DIR" "$SCHEMA_REGISTRY_LOGS_DIR" "$SCHEMA_REGISTRY_CERTS_DIR" "$SCHEMA_REGISTRY_MOUNTED_CONF_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${SCHEMA_REGISTRY_CONF_DIR}/"* "$SCHEMA_REGISTRY_DEFAULT_CONF_DIR"