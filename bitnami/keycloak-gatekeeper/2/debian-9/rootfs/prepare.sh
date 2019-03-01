#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libkeycloak.sh
. /libfs.sh

# Load Redis env. variables
eval "$(keycloak_env)"

for dir in "$KEYCLOAK_GATEKEEPER_CONFDIR" "${KEYCLOAK_GATEKEEPER_BINDIR}"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$KEYCLOAK_GATEKEEPER_CONFDIR"
chmod +x "${KEYCLOAK_GATEKEEPER_BINDIR}/keycloak-proxy"
