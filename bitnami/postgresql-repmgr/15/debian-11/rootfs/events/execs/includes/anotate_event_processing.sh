#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

header="[REPMGR EVENT::$2]"
export header
echo "$header Node id: $1; Event type: $2; Success [1|0]: $3; Time: $4;  Details: $5"

if [[ $3 -ne 1 ]];then
    echo "$header The event failed! No need to do anything."
    exit 1
fi

if [[ $1 -ne $(repmgr_get_node_id) ]]; then
    echo "$header The event did not happen on me! No need to do anything."
    exit 1
fi
