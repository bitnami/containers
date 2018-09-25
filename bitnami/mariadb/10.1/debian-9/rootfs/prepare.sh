#!/bin/bash

. /libmariadb.sh
. /libfs.sh

eval "$(mysql_env)"

for dir in "$DB_TMPDIR" "$DB_LOGDIR" "$DB_CONFDIR" "$DB_CONFDIR/bitnami" "$DB_VOLUMEDIR" "$DB_DATADIR"; do
    ensure_dir_exists "$dir"
done

chmod -R g+rwX "$DB_TMPDIR" "$DB_LOGDIR" "$DB_CONFDIR" "$DB_CONFDIR/bitnami" "$DB_VOLUMEDIR" "$DB_DATADIR"
