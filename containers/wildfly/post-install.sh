#!/bin/bash
cd $BITNAMI_APP_DIR

# set up default config
mkdir -p $BITNAMI_APP_DIR/conf.defaults/standalone
mv $BITNAMI_APP_DIR/standalone/configuration $BITNAMI_APP_DIR/conf.defaults/standalone/
ln -sf $BITNAMI_APP_DIR/conf/standalone/configuration $BITNAMI_APP_DIR/standalone/

mkdir -p $BITNAMI_APP_DIR/conf.defaults/domain
mv $BITNAMI_APP_DIR/domain/configuration $BITNAMI_APP_DIR/conf.defaults/domain/
ln -sf $BITNAMI_APP_DIR/conf/domain/configuration $BITNAMI_APP_DIR/domain/

# setup the logs
rm -rf $BITNAMI_APP_DIR/standalone/log
ln -sf $BITNAMI_APP_DIR/logs $BITNAMI_APP_DIR/standalone/log

# setup the default deployments
mv $BITNAMI_APP_DIR/standalone/deployments $BITNAMI_APP_DIR/standalone/deployments.defaults

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/standalone/deployments /app
ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
