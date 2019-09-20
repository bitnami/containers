#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /libos.sh
. /libkong.sh

# Load Kong environment variables
eval "$(kong_env)"

# Ensure Kong environment variables are valid
kong_validate
# Ensure file ownership is correct
am_i_root && chown -R "$KONG_DAEMON_USER":"$KONG_DAEMON_GROUP" "$KONG_SERVER_DIR" "$KONG_CONF_DIR"
# Ensure Kong is initialized
kong_initialize
