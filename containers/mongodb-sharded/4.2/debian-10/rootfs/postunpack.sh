#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /liblog.sh
. /libmongodb.sh
. /libmongodb-sharded.sh

# Load MongoDB env. variables
eval "$(mongodb_env)"
eval "$(mongodb_sharded_env)"

for dir in "$MONGODB_TMP_DIR" "$MONGODB_LOG_DIR" "$MONGODB_CONF_DIR" "$MONGODB_DATA_DIR" "$MONGODB_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$MONGODB_TMP_DIR" "$MONGODB_LOG_DIR" "$MONGODB_CONF_DIR" "$MONGODB_DATA_DIR" "$MONGODB_VOLUME_DIR"

# Create .dbshell file to avoid error message
touch /.dbshell /.mongorc.js && chmod g+rw /.dbshell /.mongorc.js

# Redirect all logging to stdout
ln -sf /dev/stdout "$MONGODB_LOG_FILE"
