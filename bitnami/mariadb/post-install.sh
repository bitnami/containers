#!/bin/bash

# disable DNS lookups
(
  echo "[mysqld]"
  echo "skip-name-resolve"
) >> $BITNAMI_APP_DIR/conf/my.cnf

# set up default config
mv $BITNAMI_APP_DIR/conf $BITNAMI_APP_DIR/conf.defaults

# remove existing default data and logs
rm -rf $BITNAMI_APP_DIR/data
rm -rf $BITNAMI_APP_DIR/logs

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/data $BITNAMI_APP_VOL_PREFIX/data
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
