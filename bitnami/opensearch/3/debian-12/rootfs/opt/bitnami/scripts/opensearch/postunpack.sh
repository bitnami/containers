#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libopensearch.sh
. /opt/bitnami/scripts/libfs.sh

# Load environment
. /opt/bitnami/scripts/opensearch-env.sh

for dir in "$DB_TMP_DIR" "$DB_DATA_DIR" "$DB_LOGS_DIR" "${DB_BASE_DIR}/plugins" "${DB_BASE_DIR}/modules" "${DB_BASE_DIR}/extensions" "$DB_CONF_DIR" "$DB_VOLUME_DIR" "$DB_INITSCRIPTS_DIR" "$DB_MOUNTED_PLUGINS_DIR" "$DB_DEFAULT_CONF_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R ug+rwX "$dir"
done

# Lines commented to make it possible the dynamic FIPS support using environment variables.
replace_in_file "${DB_BASE_DIR}/bin/opensearch-env" "echo \"warning: ignoring JAVA_TOOL_OPTIONS" "# echo \"warning: ignoring JAVA_TOOL_OPTIONS"
replace_in_file "${DB_BASE_DIR}/bin/opensearch-env" "unset JAVA_TOOL_OPTIONS" "true"

elasticsearch_configure_logging

for dir in "$DB_TMP_DIR" "$DB_DATA_DIR" "$DB_LOGS_DIR" "${DB_BASE_DIR}/plugins" "${DB_BASE_DIR}/modules" "$DB_CONF_DIR" "$DB_VOLUME_DIR" "$DB_INITSCRIPTS_DIR" "$DB_MOUNTED_PLUGINS_DIR" "$DB_DEFAULT_CONF_DIR"; do
    # `elasticsearch-plugin install` command complains about being unable to create the a plugin's directory
    # even when having the proper permissions.
    # The reason: the code is checking trying to check the permissions by consulting the parent directory owner,
    # instead of checking if the ES user actually has writing permissions.
    #
    # As a workaround, we will ensure the container works (at least) with the non-root user 1001. However,
    # until we can avoid this hack, we can't guarantee this container to work on K8s distributions
    # where containers are exectued with non-privileged users with random user IDs.
    #
    # Issue reported at: https://github.com/bitnami/bitnami-docker-elasticsearch/issues/50
    chown -R 1001:0 "$dir"
done

[[ -n "${DB_PLUGINS:-}" ]] && elasticsearch_install_plugins

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${DB_CONF_DIR}/"* "$DB_DEFAULT_CONF_DIR"
chmod o+rX -R "$DB_DEFAULT_CONF_DIR"

# Create a structure compatible with OpenSearch K8s Operator that's
# based on the upstream image that installs OpenSearch under /usr/share/opensearch
ln -s "$OPENSEARCH_BASE_DIR" /usr/share/opensearch
