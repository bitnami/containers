#!/bin/bash
cd $BITNAMI_APP_DIR

# create user home
mkdir -m 0755 -p /home/${BITNAMI_APP_USER}
chown -R ${BITNAMI_APP_USER}: /home/${BITNAMI_APP_USER}

# set up default config
mkdir -p $BITNAMI_APP_DIR/conf.defaults
mv $BITNAMI_APP_DIR/standalone/configuration $BITNAMI_APP_DIR/conf.defaults/standalone
mv $BITNAMI_APP_DIR/domain/configuration $BITNAMI_APP_DIR/conf.defaults/domain

# symlinks to maintain compatibility of command-line utilities (eg. add-user.sh)
ln -sf $BITNAMI_APP_DIR/conf/standalone $BITNAMI_APP_DIR/standalone/configuration
ln -sf $BITNAMI_APP_DIR/conf/domain $BITNAMI_APP_DIR/domain/configuration

# set up default datadir
mkdir -p $BITNAMI_APP_DIR/data.defaults
mv $BITNAMI_APP_DIR/standalone $BITNAMI_APP_DIR/domain $BITNAMI_APP_DIR/data.defaults/

# symlinks to maintain compatibility of command-line utilities (eg. add-user.sh)
ln -sf $BITNAMI_APP_DIR/data/standalone $BITNAMI_APP_DIR/standalone
ln -sf $BITNAMI_APP_DIR/data/domain $BITNAMI_APP_DIR/domain

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
ln -s $BITNAMI_APP_DIR/data $BITNAMI_APP_VOL_PREFIX/data
