#!/bin/bash

# Adding cron entries
ln -sf /opt/bitnami/magento/conf/cron /etc/cron.d/magento

/usr/sbin/cron
nami start --foreground apache
