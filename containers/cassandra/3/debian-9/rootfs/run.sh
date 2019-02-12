#!/bin/bash
set -o errexit
set -o pipefail

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=cassandra
DAEMON=cassandra
EXEC=$(which $DAEMON)
ARGS=("-p /opt/bitnami/cassandra/tmp/cassandra.pid" "-R" "-f")

info "Starting ${DAEMON}..."

# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    gosu "$USER" "$EXEC" "${ARGS[@]}" &
else
    "$EXEC" "${ARGS[@]}" &
fi

echo $! > /opt/bitnami/cassandra/tmp/cassandra.pid

# allow running custom initialization scripts
if [[ -z $CASSANDRA_IGNORE_INITDB_SCRIPTS ]] && [[ -n $(find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\|cql\)") ]] && [[ ! -f /bitnami/cassandra/.user_scripts_initialized ]]; then
    cmd=("cqlsh" "-u" "$CASSANDRA_USER")
    if [[ -n $CASSANDRA_PASSWORD ]]; then
        cmd+=("-p" "$CASSANDRA_PASSWORD")
    fi
    info "Initialization: Waiting for Cassandra to be available"
    cassandra_available=0
    for i in {1..60}; do
        echo "Attempt $i"
        if "${cmd[@]}" -e "DESCRIBE KEYSPACES"; then
            cassandra_available=1
            break
        fi
        sleep 10
    done
    if [[ $cassandra_available == 0 ]]; then
        echo "Error: Cassandra is not available after 600 seconds" 
        exit 1
    fi
    info "Loading user files from /docker-entrypoint-initdb.d";
    tmp_file=/tmp/filelist
    find /docker-entrypoint-initdb.d/ -type f -regex ".*\.\(sh\|cql\)" > $tmp_file
    while read -r f; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    echo "Executing $f"; "$f"
                else
                    echo "Sourcing $f"; . "$f"
                fi
                ;;
            *.cql)    echo "Executing $f"; "${cmd[@]}" -f "$f"; echo ;;
            *)        echo "Ignoring $f" ;;
        esac
    done < $tmp_file
    rm $tmp_file
    touch /bitnami/cassandra/.user_scripts_initialized
fi

wait
