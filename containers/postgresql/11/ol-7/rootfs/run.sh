#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

POSTGRESQL_BASE_DIR="/opt/bitnami/postgresql"
MOUNT_POINT_DIR="${POSTGRESQL_DATA_DIR:-/bitnami/postgresql}"
DATA_DIR="${MOUNT_POINT_DIR}/data"
CONF_FILE="${POSTGRESQL_BASE_DIR}/conf/postgresql.conf"
PID_FILE="${POSTGRESQL_BASE_DIR}/tmp/postgresql.pid"
PG_HBA_FILE="${POSTGRESQL_BASE_DIR}/data/pg_hba.conf"

START_ARGS=("-D" "$DATA_DIR" "--config-file=$CONF_FILE" "--external_pid_file=$PID_FILE" "--hba_file=$PG_HBA_FILE")
STOP_ARGS=("stop" "-w" "-D" "$DATA_DIR")

function postgresqlStart {
    # If container is started as `root` user
    if [ $EUID -eq 0 ]; then
        exec gosu postgres postgres "${START_ARGS[@]}"
    else
        exec postgres "${START_ARGS[@]}"
    fi
}

function postgresqlStop {
    # If container is started as `root` user
    if [ $EUID -eq 0 ]; then
        gosu postgres pg_ctl "${STOP_ARGS[@]}"
    else
        pg_ctl "${STOP_ARGS[@]}"
    fi
}

if [ "${LD_PRELOAD:-}" = '/usr/lib/libnss_wrapper.so' ]; then
        rm -f "$NSS_WRAPPER_PASSWD" "$NSS_WRAPPER_GROUP"
        unset LD_PRELOAD NSS_WRAPPER_PASSWD NSS_WRAPPER_GROUP
fi

# allow running custom initialization scripts
if [[ -n $(find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\|sql\|sql.gz\)") ]] && [[ ! -f /bitnami/postgresql/.user_scripts_initialized ]]; then
    info "Loading user files from /docker-entrypoint-initdb.d";
    if [[ -n $POSTGRESQL_PASSWORD ]] && [[ $POSTGRESQL_USERNAME == "postgres" ]]; then
        export PGPASSWORD=$POSTGRESQL_PASSWORD
    fi
    psql=( psql --username postgres )
    postgresqlStart &
    info "Initialization: Waiting for PostgreSQL to be available"
    postgresql_available=0
    for i in {1..60}; do
        log "Attempt $i"
        if grep "is ready to accept connections" /opt/bitnami/postgresql/logs/postgresql.log > /dev/null; then
            postgresql_available=1
            break
        fi
        sleep 10
    done
    if [[ $postgresql_available == 0 ]]; then
        echo "Error: PostgreSQL is not available after 600 seconds"
        exit 1
    fi
    tmp_file=/tmp/filelist
    find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\|sql\|sql.gz\)" > $tmp_file
    while read -r f; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    echo "Executing $f"; "$f"
                else
                    echo "Sourcing $f"; . "$f"
                fi
                ;;
            *.sql)    echo "Executing $f"; "${psql[@]}" -f "$f"; echo ;;
            *.sql.gz) echo "Executing $f"; gunzip -c "$f" | "${psql[@]}"; echo ;;
            *)        echo "Ignoring $f" ;;
        esac
    done < $tmp_file
    rm $tmp_file
    touch /bitnami/postgresql/.user_scripts_initialized
    postgresqlStop
fi

postgresqlStart
