#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# shellcheck disable=SC2154
echo  "$header Locking primary..."
echo "$4" >> "$REPMGR_PRIMARY_ROLE_LOCK_FILE_NAME"
