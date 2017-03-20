#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=ghost

export NODE_ENV=production

info "Starting ghost..."
exec gosu ${USER} /opt/bitnami/ghost/node_modules/pm2/bin/pm2 start --no-daemon --merge-logs /opt/bitnami/ghost/index.js
