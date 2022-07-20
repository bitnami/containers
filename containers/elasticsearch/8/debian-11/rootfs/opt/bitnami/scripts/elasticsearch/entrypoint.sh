#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libelasticsearch.sh

# Load environment
. /opt/bitnami/scripts/elasticsearch-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/elasticsearch/run.sh" ]]; then
    info "** Starting Elasticsearch setup **"
    /opt/bitnami/scripts/elasticsearch/setup.sh
    info "** Elasticsearch setup finished! **"
fi

echo ""
exec "$@"
