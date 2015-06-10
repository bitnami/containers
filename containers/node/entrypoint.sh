#!/bin/bash
set -e
source /bitnami-utils.sh

print_welcome_page
exec "$@"
