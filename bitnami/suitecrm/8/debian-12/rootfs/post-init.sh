#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Only execute init scripts once
if [[ ! -f "/bitnami/suitecrm/.user_scripts_initialized" && -d "/docker-entrypoint-init.d" ]]; then
    read -r -a init_scripts <<< "$(find "/docker-entrypoint-init.d" -type f -print0 | sort -z | xargs -0)"
    if [[ "${#init_scripts[@]}" -gt 0 ]] && [[ ! -f "/bitnami/suitecrm/.user_scripts_initialized" ]]; then
        mkdir -p "/bitnami/suitecrm"
        for init_script in "${init_scripts[@]}"; do
            for init_script_type_handler in /post-init.d/*.sh; do
                "$init_script_type_handler" "$init_script"
            done
        done
    fi

    touch "/bitnami/suitecrm/.user_scripts_initialized"
fi
