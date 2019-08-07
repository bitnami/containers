#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh

FLAGS=''

if [[ -d "/bitnami/certs" ]]; then
    FLAGS='--tls-cert /bitnami/certs/server.crt --tls-key /bitnami/certs/server.key'
fi

if [[ -z ${STORAGE:-} ]]; then
   info "Using local storage into /bitnami/data directory"
   STORAGE='local'
   STORAGE_LOCAL_ROOTDIR='/bitnami/data'
   FLAGS="$FLAGS --storage $STORAGE --storage-local-rootdir $STORAGE_LOCAL_ROOTDIR"
 fi

 info "** Starting chartmuseum **"
 exec /opt/bitnami/chartmuseum/bin/chartmuseum $FLAGS
