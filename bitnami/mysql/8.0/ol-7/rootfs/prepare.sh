#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /libmysql.sh

# Load MySQL env. variables
eval "$(mysql_env)"

for dir in "$DB_TMPDIR" "$DB_LOGDIR" "$DB_CONFDIR" "${DB_CONFDIR}/bitnami" "$DB_VOLUMEDIR" "$DB_DATADIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$DB_TMPDIR" "$DB_LOGDIR" "$DB_CONFDIR" "${DB_CONFDIR}/bitnami" "$DB_VOLUMEDIR" "$DB_DATADIR"

# Redirect all logging to stdout
ln -sf /dev/stdout "$DB_LOGDIR/mysqld.log"
