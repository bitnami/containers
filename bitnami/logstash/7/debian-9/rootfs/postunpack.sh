#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /libfs.sh
. /liblogstash.sh

# Load Logstash environment variables
eval "$(logstash_env)"

for dir in "$LOGSTASH_CONF_DIR" "$LOGSTASH_LOG_DIR" "$LOGSTASH_MOUNTED_CONF_DIR" "$LOGSTASH_VOLUME_DIR" "$LOGSTASH_DATA_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

