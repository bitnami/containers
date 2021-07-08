#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Neo4j environment
. /opt/bitnami/scripts/neo4j-env.sh

# Load libraries
. /opt/bitnami/scripts/libneo4j.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Ensure the Neo4j base directory exists and has proper permissions
info "Configuring file permissions for Neo4j"

## File directory permissions
## Source: https://neo4j.com/docs/operations-manual/current/configuration/file-locations/#file-locations-permissions

## Directories that should have read-only permissions
for dir in "$NEO4J_IMPORT_DIR" "${NEO4J_BASE_DIR}/lib" "$NEO4J_CERTIFICATES_DIR" "$NEO4J_MOUNTED_CONF_DIR" "$NEO4J_MOUNTED_PLUGINS_DIR" "$NEO4J_INITSCRIPTS_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -u "root" -g "root" -d 555 -f 444
done

## Directories that should have write permissions
## NOTE: We need the configuration and plugins folder to have write permissions to create or import the configuration file
for dir in "$NEO4J_CONF_DIR" "$NEO4J_PLUGINS_DIR" "$NEO4J_LOGS_DIR" "$NEO4J_DATA_DIR" "$NEO4J_TMP_DIR" "$NEO4J_METRICS_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -u "root" -g "root" -d 775 -f 664
done

info "Configuring default settings in configuration files"
## Configure the default paths for neo4j
## Source: https://neo4j.com/docs/operations-manual/current/configuration/file-locations/#file-locations
neo4j_conf_set "dbms.directories.data" "$NEO4J_DATA_DIR"
neo4j_conf_set "dbms.directories.plugins" "$NEO4J_PLUGINS_DIR"
neo4j_conf_set "dbms.directories.logs" "$NEO4J_LOGS_DIR"
neo4j_conf_set "dbms.directories.import" "$NEO4J_IMPORT_DIR"
neo4j_conf_set "dbms.directories.transaction.logs.root" "${NEO4J_DATA_DIR}/transactions"
neo4j_conf_set "dbms.directories.dumps.root" "${NEO4J_DATA_DIR}/dumps"

## Create empty file for apoc.conf file as it is not included in the default neo4j installation
## Source: https://neo4j.com/labs/apoc/4.2/config/
touch "$NEO4J_APOC_CONF_FILE"
neo4j_conf_set "apoc.import.file.enabled" "true" "$NEO4J_APOC_CONF_FILE"
neo4j_conf_set "apoc.import.file.use_neo4j_config" "false" "$NEO4J_APOC_CONF_FILE"
configure_permissions_ownership "$NEO4J_APOC_CONF_FILE" -u "root" -g "root" -f 664
