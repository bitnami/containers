#!/bin/bash -e
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

exec "$@"
