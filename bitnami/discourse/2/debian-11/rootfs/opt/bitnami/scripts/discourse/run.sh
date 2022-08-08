#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Discourse environment
. /opt/bitnami/scripts/discourse-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libdiscourse.sh

cd "$DISCOURSE_BASE_DIR"

declare -a cmd=(
    chpst -u "$DISCOURSE_DAEMON_USER" -U "$DISCOURSE_DAEMON_USER" "bundle" "exec" "config/unicorn_launcher"
    "-E" "$DISCOURSE_ENV"
    "-p" "$DISCOURSE_PORT_NUMBER"
    "-c" "config/unicorn.conf.rb"
)

# Append extra flags specified via environment variables
if [[ -n "$DISCOURSE_PASSENGER_EXTRA_FLAGS" ]]; then
    declare -a passenger_extra_flags
    read -r -a passenger_extra_flags <<< "$DISCOURSE_PASSENGER_EXTRA_FLAGS"
    [[ "${#passenger_extra_flags[@]}" -gt 0 ]] && cmd+=("${passenger_extra_flags[@]}")
fi

info "** Starting Discourse **"
USER=$DISCOURSE_DAEMON_USER exec "${cmd[@]}" "$@"
