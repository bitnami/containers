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
