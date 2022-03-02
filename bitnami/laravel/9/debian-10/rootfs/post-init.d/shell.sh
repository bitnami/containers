#!/bin/bash
#
# Executes custom Bash init scripts

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries with logging functions
if [[ -f /opt/bitnami/base/functions ]]; then
    . /opt/bitnami/base/functions
else
    . /opt/bitnami/scripts/liblog.sh
fi

# Loop through all input files passed via stdin
read -r -a custom_init_scripts <<< "$@"
failure=0
if [[ "${#custom_init_scripts[@]}" -gt 0 ]]; then
    for custom_init_script in "${custom_init_scripts[@]}"; do
        [[ "$custom_init_script" != *".sh" ]] && continue
        if [[ -x "$custom_init_script" ]]; then
            info "Executing ${custom_init_script}"
            "$custom_init_script" || failure="1"
        else
            info "Sourcing ${custom_init_script} as it is not executable by the current user, any error may cause initialization to fail"
            . "$custom_init_script"
        fi
        [[ "$failure" -ne 0 ]] && error "Failed to execute ${custom_init_script}"
    done
fi

exit "$failure"
