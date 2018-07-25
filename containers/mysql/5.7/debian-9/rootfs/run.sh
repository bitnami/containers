#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers


DAEMON=mysqld_safe
EXEC=$(which $DAEMON)
ARGS="--defaults-file=/opt/bitnami/mysql/conf/my.cnf"


# configure command line flags for replication
if [[ -n "$MYSQL_REPLICATION_MODE" ]]; then
    ARGS+=" --server-id=$RANDOM --binlog-format=ROW --log-bin=mysql-bin --sync-binlog=1"
    case "$MYSQL_REPLICATION_MODE" in
        master)
            ARGS+=" --innodb_flush_log_at_trx_commit=1"
            ;;
        slave)
            ARGS+=" --relay-log=mysql-relay-bin --log-slave-updates=1 --read-only=1 --master-info-repository=TABLE --relay-log-info-repository=TABLE"
            ;;
    esac
fi

# configure extra command line flags
if [[ -n "$MYSQL_EXTRA_FLAGS" ]]; then
    ARGS+=" $MYSQL_EXTRA_FLAGS"
fi

info "Starting ${DAEMON}..."

exec ${EXEC} ${ARGS}
