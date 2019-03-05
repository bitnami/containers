#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libos.sh
. /libkeycloak.sh

# Load Keycloak Gatekeeper environment variables
eval "$(keycloak_env)"


flags=("--verbose" "$@")
if [[ -f "${KEYCLOAK_GATEKEEPER_CONFDIR}/config.yml" ]]; then
    flags=("--config" "${KEYCLOAK_GATEKEEPER_CONFDIR}/config.yml" "${flags[@]}")
fi

info "** Starting Keycloak Gatekeeper **"
debug "Flags used: ${flags[*]}"
if am_i_root; then
    exec gosu "$KEYCLOAK_GATEKEEPER_DAEMON_USER" "${KEYCLOAK_GATEKEEPER_BINDIR}/keycloak-proxy" "${flags[@]}"
else
    exec "${KEYCLOAK_GATEKEEPER_BINDIR}/keycloak-proxy" "${flags[@]}"
fi
