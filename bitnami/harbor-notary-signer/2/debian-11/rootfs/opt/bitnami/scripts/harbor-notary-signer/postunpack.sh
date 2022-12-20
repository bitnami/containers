#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libharbor.sh

# Load environment
. /opt/bitnami/scripts/harbor-notary-signer-env.sh

ensure_user_exists "$HARBOR_NOTARY_SIGNER_DAEMON_USER" --group "$HARBOR_NOTARY_SIGNER_DAEMON_GROUP"

# Ensure a set of directories exist and the non-root user has write privileges to them
ensure_dir_exists "/etc/notary"
chmod -R g+rwX "/etc/notary"
chown -R "$HARBOR_NOTARY_SIGNER_DAEMON_USER" "/etc/notary"
