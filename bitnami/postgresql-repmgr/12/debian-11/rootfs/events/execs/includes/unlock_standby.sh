#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# shellcheck disable=SC2154
echo "$header Unlocking standby..."
rm -f "$REPMGR_STANDBY_ROLE_LOCK_FILE_NAME"
