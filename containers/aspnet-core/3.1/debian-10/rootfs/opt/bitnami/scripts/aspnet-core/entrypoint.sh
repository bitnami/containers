#!/bin/bash -e

# shellcheck disable=SC1091

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

exec "$@"
