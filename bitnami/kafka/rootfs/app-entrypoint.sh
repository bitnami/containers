#!/bin/bash
set -e


ln -sf /bitnami/kafka /opt/bitnami/kafka
# Set default values

exec /entrypoint.sh "$@"
