#!/bin/bash

: ${BITNAMI_APP_DIRNAME=$BITNAMI_APP_NAME};

echo "===> Downloading Bitnami $BITNAMI_APP_NAME-$BITNAMI_APP_VERSION installer"
apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get install -qy wget
wget -q --no-check-certificate \
  https://downloads.bitnami.com/files/download/$BITNAMI_APP_NAME/\
bitnami-$BITNAMI_APP_NAME-$BITNAMI_APP_VERSION-linux-x64-installer.run \
  -O /tmp/installer.run

echo "===> Running Bitnami $BITNAMI_APP_NAME-$BITNAMI_APP_VERSION installer"
chmod +x /tmp/installer.run
/tmp/installer.run --mode unattended --prefix /opt/bitnami $@
/opt/bitnami/$BITNAMI_APP_DIRNAME/scripts/ctl.sh stop > /dev/null

if [ -f "/tmp/post-install.sh" ]; then
  sh /tmp/post-install.sh /opt/bitnami/$BITNAMI_APP_DIRNAME
fi

echo "===> Cleaning up"
rm -rf /tmp/* /opt/bitnami/ctlscript.sh /opt/bitnami/config
DEBIAN_FRONTEND=noninteractive apt-get --purge autoremove -qy wget
apt-get clean && rm -rf /var/lib/apt && rm -rf /var/cache/apt/archives/*
