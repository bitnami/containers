#!/bin/bash

# set -o xtrace # Uncomment this line for debugging purposes

. /opt/bitnami/base/functions

if [[ -d /docker-entrypoint-init.d ]] && [[ ! -f "/bitnami/drupal/.user_scripts_initialized" ]]; then
    for f in /docker-entrypoint-init.d/*; do
        for p in /post-init.d/*.sh; do
            "$p" "$f"
        done
    done
    info "Custom scripts were executed"
    touch "/bitnami/drupal/.user_scripts_initialized"
fi
