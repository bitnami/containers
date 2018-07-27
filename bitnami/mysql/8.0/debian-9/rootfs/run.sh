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

# allow running custom initialization scripts
if [[ -n $(find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\|sql\|sql.gz\)") ]] && [[ ! -f /bitnami/mysql/.user_scripts_initialized ]] ; then
    echo "==> Loading user files from /docker-entrypoint-initdb.d";
    if [[ -n "$MYSQL_ROOT_PASSWORD" ]]; then
        mysql=( mysql -uroot -p$MYSQL_ROOT_PASSWORD -hlocalhost )
        mysqladmin=( mysqladmin -uroot -p$MYSQL_ROOT_PASSWORD -hlocalhost )
    else
        mysql=( mysql -uroot -hlocalhost )
        mysqladmin=( mysqladmin -uroot -hlocalhost )
    fi
    if [[ -n "$MYSQL_DATABASE" ]]; then
        mysql+=( "$MYSQL_DATABASE" )
    fi
    ${EXEC} ${ARGS} &
    for i in {30..0}; do
        if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
            break
        fi
        info "MySQL init process in progress..."
        sleep 1
    done
    if [ $i = 0 ]; then
        error 'MySQL init process failed.'
    fi
    MYSQL_PID="$!"

    for f in /docker-entrypoint-initdb.d/*; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    echo "Executing $f"; "$f"
                else
                    echo "Sourcing $f"; . "$f"
                fi
                ;;
            *.sql)    echo "Executing $f"; "${mysql[@]}" < "$f"; echo ;;
            *.sql.gz) echo "Executing $f"; gunzip -c "$f" | "${mysql[@]}"; echo ;;
            *)        echo "Ignoring $f" ;;
        esac
    done
    touch /bitnami/mysql/.user_scripts_initialized
    if ! "${mysqladmin[@]}" shutdown || ! wait "$MYSQL_PID"; then
        echo >&2 'MySQL init process failed.'
        exit 1
    fi
fi

info "Starting ${DAEMON}..."
exec ${EXEC} ${ARGS}
