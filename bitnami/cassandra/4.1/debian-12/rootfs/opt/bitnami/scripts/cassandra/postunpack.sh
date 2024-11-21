#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libcassandra.sh

# Load Cassandra environment variables
. /opt/bitnami/scripts/cassandra-env.sh

# Starting with version 5.0.2, we found that the Cassandra official configuration
# was in a file called cassandra_latest.yaml. We copy that file to ensure that it is using
# the latest settings
if [[ -f "${DB_DEFAULT_CONF_DIR}/cassandra_latest.yaml" ]]; then
    cp "${DB_DEFAULT_CONF_DIR}/cassandra_latest.yaml" "${DB_DEFAULT_CONF_DIR}/cassandra.yaml"
fi

for dir in "$DB_INITSCRIPTS_DIR" "$DB_TMP_DIR" "$DB_LOG_DIR" "$DB_MOUNTED_CONF_DIR" "$DB_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Copy configuration files for the scripts to work
ensure_dir_exists "$DB_CONF_DIR"
cassandra_copy_default_config
chmod -R g+rwX "$DB_CONF_DIR"

# Create wrapper for cqlsh
cat <<EOF >"${DB_BIN_DIR}/cqlsh"
#!/bin/sh
exec "${PYTHON_BIN_DIR}/python" "${DB_BIN_DIR}/cqlsh.py" "\$@"
EOF

chmod +x "${DB_BIN_DIR}/cqlsh"

ensure_dir_exists "${HOME}/.cassandra"
chmod -R g+rwX "${HOME}/.cassandra"
