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
    if [[ ! -z $POSTGRESQL_PASSWORD ]]; then
        export PGPASSWORD=$POSTGRESQL_PASSWORD
    fi
    psql=( psql --username $POSTGRESQL_USERNAME )
    if [[ -n $POSTGRESQL_DATABASE ]]; then
        psql+=( --dbname $POSTGRESQL_DATABASE )
    fi
    nami start postgresql > /dev/null
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
