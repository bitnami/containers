#!/bin/bash
cd $BITNAMI_APP_DIR

# create user home
mkdir -m 0755 -p /home/${BITNAMI_APP_USER}
chown -R ${BITNAMI_APP_USER}: /home/${BITNAMI_APP_USER}

# set up default config
mkdir -p $BITNAMI_APP_DIR/conf.defaults/standalone
mv $BITNAMI_APP_DIR/standalone/configuration $BITNAMI_APP_DIR/conf.defaults/standalone/
ln -sf $BITNAMI_APP_DIR/conf/standalone/configuration $BITNAMI_APP_DIR/standalone/

mkdir -p $BITNAMI_APP_DIR/conf.defaults/domain
mv $BITNAMI_APP_DIR/domain/configuration $BITNAMI_APP_DIR/conf.defaults/domain/
ln -sf $BITNAMI_APP_DIR/conf/domain/configuration $BITNAMI_APP_DIR/domain/

# setup the default deployments
mv $BITNAMI_APP_DIR/standalone/deployments $BITNAMI_APP_DIR/standalone/deployments.defaults

# Create an empty deployments directory
mkdir -p $BITNAMI_APP_DIR/standalone/deployments

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/standalone/deployments /app
ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
