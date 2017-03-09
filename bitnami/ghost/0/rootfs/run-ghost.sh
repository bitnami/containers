#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

info "Starting ghost..."
exec /opt/bitnami/ghost/node_modules/pm2/bin/pm2 start --no-daemon index.js
