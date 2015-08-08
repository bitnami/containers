# #!/bin/bash
cd $BITNAMI_APP_DIR

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/data $BITNAMI_APP_VOL_PREFIX/data
