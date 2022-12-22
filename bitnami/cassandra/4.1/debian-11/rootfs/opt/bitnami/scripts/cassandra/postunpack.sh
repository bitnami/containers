#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libcassandra.sh

# Load Cassandra environment variables
. /opt/bitnami/scripts/cassandra-env.sh

for dir in "$CASSANDRA_INITSCRIPTS_DIR" "$CASSANDRA_TMP_DIR" "$CASSANDRA_HISTORY_DIR" "$CASSANDRA_CONF_DIR" "$CASSANDRA_LOG_DIR" "$CASSANDRA_MOUNTED_CONF_DIR" "$CASSANDRA_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Create wrapper for cqlsh
cat <<EOF >"${CASSANDRA_BIN_DIR}/cqlsh"
#!/bin/sh
exec "${PYTHON_BIN_DIR}/python" "${CASSANDRA_BIN_DIR}/cqlsh.py" "\$@"
EOF

chmod +x "${CASSANDRA_BIN_DIR}/cqlsh"
