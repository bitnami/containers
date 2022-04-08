#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

print_welcome_page

# Configure libnss_wrapper based on the UID/GID used to run the container
# This container supports arbitrary UIDs, therefore we have do it dynamically
if ! am_i_root && ! user_exists "$(id -u)" && [[ -f "$LIBNSS_WRAPPER_PATH" ]]; then
    info "Configuring libnss_wrapper"
    NSS_WRAPPER_PASSWD="$(mktemp)"
    export NSS_WRAPPER_PASSWD
    NSS_WRAPPER_GROUP="$(mktemp)"
    export NSS_WRAPPER_GROUP
    echo "argocd:x:$(id -u):$(id -g):ArgoCD:/opt/bitnami/argo-cd:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "argocd:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
    chmod 400 "$NSS_WRAPPER_PASSWD" "$NSS_WRAPPER_GROUP"
fi

exec /opt/bitnami/argo-cd/bin/argocd
