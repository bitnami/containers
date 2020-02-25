#!/bin/bash

. /opt/bitnami/base/functions

if [[ -d /docker-entrypoint-init.d ]] && [[ ! -f "/bitnami/$BITNAMI_APP_NAME/.user_scripts_initialized" ]]; then
    for f in /docker-entrypoint-init.d/*; do
        failure=0
        case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    info "Executing $f"; "$f" || failure=$?
                else
                    info "Sourcing $f"; . "$f"
                fi
                ;;

            *.php)
                info "Executing $f with PHP interpreter"
                php "$f" || failure=$?
                ;;

            *.sql|*.sql.gz)
                info "Executing $f"
                mysql_cmd=( mysql -h "$MARIADB_HOST" -P "$MARIADB_PORT_NUMBER" -u "$MARIADB_ROOT_USER" )
                if [[ "${ALLOW_EMPTY_PASSWORD:-no}" != "yes" ]]; then
                    mysql_cmd+=( -p"$MARIADB_ROOT_PASSWORD" )
                fi
                if [[ "$f" == *".sql" ]]; then
                    "${mysql_cmd[@]}" < "$f" || failure=$?
                elif [[ "$f" == *".sql.gz" ]]; then
                    gunzip -c "$f" | "${mysql_cmd[@]}" || failure=$?
                fi
                ;;

            *)
                info "Ignoring $f"
                ;;
        esac
        if [[ "$failure" -ne 0 ]]; then
            error "Failed to execute $f"
            exit "$failure"
        fi
    done
    info "Custom scripts were executed"
    touch "/bitnami/$BITNAMI_APP_NAME/.user_scripts_initialized"
fi
