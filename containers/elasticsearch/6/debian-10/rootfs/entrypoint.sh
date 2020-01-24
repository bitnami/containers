#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /libelasticsearch.sh

# Load Elasticsearch environment variables
eval "$(elasticsearch_env)"

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting Elasticsearch setup **"
    /setup.sh
    info "** Elasticsearch setup finished! **"
fi

echo ""
exec "$@"
