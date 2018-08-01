#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

. /libbitnami.sh
. /libnginx.sh && eval "$(nginx_env)"

print_welcome_page

if [ "$*" = "/run.sh" ]; then
    /setup.sh
fi


exec "$@"
