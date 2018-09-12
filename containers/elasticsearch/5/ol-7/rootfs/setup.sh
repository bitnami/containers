#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

. /libos.sh
. /libfs.sh
. /libelasticsearch.sh

eval "$(elasticsearch_env)"

# ensure elasticsearch env var settings are valid
elasticsearch_validate

# ensure elasticsearch is stopped when this script ends.
trap "elasticsearch_stop" EXIT

if am_i_root; then
    ensure_user_exists "$ELASTICSEARCH_DAEMON_USER" "$ELASTICSEARCH_DAEMON_GROUP"
fi

# ensure elasticsearch is initialized
elasticsearch_initialize

