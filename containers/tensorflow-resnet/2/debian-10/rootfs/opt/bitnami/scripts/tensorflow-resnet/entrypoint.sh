#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load solr environment variables
. /opt/bitnami/scripts/tensorflow-resnet-env.sh

print_welcome_page

info "** Starting tensorflow resnet **"

if ! retry_while "wait-for-port --host $TF_RESNET_SERVING_HOST --timeout 10 $TF_RESNET_SERVING_PORT_NUMBER" ; then
    error "Unable to connect to host $TF_RESNET_SERVING_HOST"
    exit 1
fi

echo ""
exec "$@"
