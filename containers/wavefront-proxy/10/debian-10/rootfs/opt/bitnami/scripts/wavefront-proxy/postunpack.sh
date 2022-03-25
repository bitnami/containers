#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Replicate official container structure to serve as a drop-in container image replacement
mkdir -p /opt/bitnami/tmp /etc/wavefront /var/log/wavefront
chmod g+rwX /opt/bitnami/tmp /var/log/wavefront
ln -s /opt/bitnami /opt/wavefront
ln -s /opt/bitnami/wavefront-proxy/etc /etc/wavefront/wavefront-proxy
ln -s /opt/bitnami/wavefront-proxy/tmp /var/spool/wavefront-proxy
ln -s /opt/bitnami/wavefront-proxy/scripts/run.sh /run.sh
# Starting frow v11.x.x we also need this symlink
ln -s /opt/bitnami/wavefront-proxy/bin/wavefront-proxy.jar /opt/wavefront/wavefront-proxy/wavefront-proxy.jar
