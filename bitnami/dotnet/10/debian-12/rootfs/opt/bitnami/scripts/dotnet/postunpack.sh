#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
mkdir /app
chmod g+rwx /app
setcap CAP_NET_BIND_SERVICE=+eip /opt/bitnami/dotnet/bin/dotnet
