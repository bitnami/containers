#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libscylladb.sh

# Load ScyllaDB environment variables
. /opt/bitnami/scripts/scylladb-env.sh


for dir in "$DB_INITSCRIPTS_DIR" "$DB_TMP_DIR" "$DB_LOG_DIR" "$DB_CONF_DIR" "$DB_MOUNTED_CONF_DIR" "$DB_VOLUME_DIR" "$DB_DEFAULT_CONF_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# HACK: The scylla.yaml file is not consistently formatted, having sections like this:
# 1) "#value: 123"
# 2) "# value2: 123"
# This is causing the cassandra_yaml_set function to not work as expected. To workaround that, we fix this
# issue by changing all expressions like 1) to be like 2)
replace_in_file "$DB_CONF_FILE" "^#([a-zA-Z])" "# \1"

# The client_encryption_options and server_encryption_options are commented in scylla.yaml.
# We remove the comment to make it consistent with cassandra.yaml and the logic works for both
replace_in_file "$DB_CONF_FILE" "^#\s*client_encryption_options:" "client_encryption_options:"
replace_in_file "$DB_CONF_FILE" "^#\s*server_encryption_options:" "server_encryption_options:"

# Set scylladb workdir to data directory
cassandra_yaml_set "workdir" "$DB_DATA_DIR"

# The scylladb-jmx script has a "symlinks" directory with a scylla-jmx file, which is a symlink
# to /usr/bin/java. We update the symlink to point to /opt/bitnami/java/bin/java. We also need to
# include a symlink in the /usr/lib/jvm/ directory for the scylla-jmx select-java script to work
ln -sf "${BITNAMI_ROOT_DIR}/java/bin/java" "/usr/bin/java"
mkdir -p "/usr/lib/jvm" && ln -s "${BITNAMI_ROOT_DIR}/java" "/usr/lib/jvm"

# Create wrapper for cqlsh, as the default one is unable to properly detect the python version
cat <<EOF >"${DB_BASE_DIR}/share/cassandra/bin/cqlsh"
#!/bin/sh
exec "${PYTHON_BIN_DIR}/python" "${DB_BASE_DIR}/share/cassandra/bin/cqlsh.py" "\$@"
EOF

chmod +x "${DB_BASE_DIR}/share/cassandra/bin/cqlsh"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${DB_CONF_DIR}/"* "$DB_DEFAULT_CONF_DIR"
chmod o+rX -R "$DB_DEFAULT_CONF_DIR"

ensure_dir_exists "${HOME}/.cassandra"
chmod -R g+rwX "${HOME}/.cassandra"

# Add symlinks for adding compatibility with the upstream scylladb-operator
ln -s "$DB_DATA_DIR" "/var/lib/scylladb"
ln -s "$DB_CONF_DIR/scylla" "/etc/scylla"
ln -s "$DB_CONF_DIR/scylla.d" "/etc/scylla.d"
ln -s "$DB_CONF_DIR/sysconfig" "/etc/sysconfig"
ln -s "$DB_CONF_DIR/bash_completion.d" "/etc/bash_completion.d"
ln -s "$DB_LOG_DIR" "/var/log/scylla"
ln -s "$DB_BASE_DIR" "/opt/scylladb"

# The scripts in the docker folder need to be copied to / in order to work with the operator
cp -r "${DB_BASE_DIR}/docker/"* /

# Adapt the shebang of the operator python scripts so they use the scylladb python venv instead of
# the installed python, as there would be missing packages
for pyscript in /*.py; do
    replace_in_file "$pyscript" "#!/usr/bin/env python3" "#!${DB_BASE_DIR}/python3/bin/python3"
done

# The scylladb-operator expects the supervisor binaries to be in /usr/bin, so we need
# to create a symlink
ln -s /opt/bitnami/supervisor/bin/supervisord /usr/bin
ln -s /opt/bitnami/supervisor/bin/supervisorctl /usr/bin