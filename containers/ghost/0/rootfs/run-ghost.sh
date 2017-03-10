#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

export NODE_ENV=production

info "Starting ghost..."
exec /opt/bitnami/ghost/node_modules/pm2/bin/pm2 start --no-daemon /opt/bitnami/ghost/index.js
