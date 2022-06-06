#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
mkdir /app
chmod g+rwx /app
ln -fs /usr/lib/libz.so.1 /lib64/libz.so
setcap CAP_NET_BIND_SERVICE=+eip /opt/bitnami/dotnet-sdk/bin/dotnet
