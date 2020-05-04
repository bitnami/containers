#!/bin/bash

. /opt/bitnami/base/functions

if [[ -d /docker-entrypoint-init.d ]] && [[ ! -f "/bitnami/moodle/.user_scripts_initialized" ]]; then
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

            *.pl)
                info "Executing $f with Perl interpreter"
                perl "$f" || failure=$?
                ;;

            *.php)
                info "Executing $f with PHP interpreter"
                php "$f" || failure=$?
                ;;

            *.sql|*.sql.gz)
                info "Executing $f"
                if [[ -n "$POSTGRESQL_PASSWORD" ]]; then
                    export PGPASSWORD=$POSTGRESQL_PASSWORD
                fi
                if [[ -n "${POSTGRESQL_USER:-}" ]]; then
                    psql=( psql -U $POSTGRESQL_USER )
                else
                    psql=( psql -U $POSTGRESQL_USERNAME )
                fi
                if [[ "$f" == *".sql" ]]; then
                    "${psql[@]}" -f "$f" || failure=$?
                elif [[ "$f" == *".sql.gz" ]]; then
                    gunzip -c "$f" | "${psql[@]}" || failure=$?
                fi
                echo
                ;;

            *.py)
                info "Executing $f with Python interpreter"
                python "$f" || failure=$?
                ;;

            *.rb)
                info "Executing $f with Ruby interpreter"
                ruby "$f" || failure=$?
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
    touch "/bitnami/moodle/.user_scripts_initialized"
fi
