#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

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
    nami start postgresql > /dev/null
    info "Initialization: Waiting for PostgreSQL to be available"
    postgresql_available=0
    for i in {1..60}; do
        debug "Attempt $i"
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
    for f in /docker-entrypoint-initdb.d/*; do
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
    done
    touch /bitnami/postgresql/.user_scripts_initialized
    nami stop postgresql > /dev/null
fi

nami start --foreground postgresql
