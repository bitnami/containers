#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libscylladb.sh
. /opt/bitnami/scripts/libos.sh

# Load ScyllaDB environment variables
. /opt/bitnami/scripts/scylladb-env.sh

info "** Starting ScyllaDB **"

EXEC="${DB_BIN_DIR}/scylla"

flags=("--options-file" "$DB_CONF_FILE")
if is_boolean_yes "$SCYLLADB_DEVELOPER_MODE"; then
    flags+=("--developer-mode" "true")
fi

# Add DB_SMP flag if the variable is set
if [[ -n "${DB_SMP}" ]]; then
    flags+=("--smp" "$DB_SMP")
fi

# Add DB_CPUSET flag if the variable is set
if [[ -n "${DB_CPUSET}" ]]; then
    flags+=("--cpuset" "$DB_CPUSET")
fi

# Add DB_MEMORY flag if the variable is set
if [[ -n "${DB_MEMORY}" ]]; then
    flags+=("--memory" "$DB_MEMORY")
fi

# Add flags passed to this script
flags+=("$@")

info "** Starting $DB_FLAVOR **"
if am_i_root; then
    exec_as_user "$DB_DAEMON_USER" "$EXEC" "${flags[@]}"
else
    exec "$EXEC" "${flags[@]}"
fi