#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /libtomcat.sh

# Load Tomcat environment variables
eval "$(tomcat_env)"

for dir in "$TOMCAT_TMP_DIR" "$TOMCAT_LOG_DIR" "$TOMCAT_CONF_DIR" "$TOMCAT_WORK_DIR" "$TOMCAT_WEBAPPS_DIR"; do
    ensure_dir_exists "$dir"
done

mv "$TOMCAT_BASE_DIR/webapps" "$TOMCAT_BASE_DIR/webapps_default"
ln -s "$TOMCAT_WEBAPPS_DIR" "$TOMCAT_BASE_DIR/webapps"
ln -s "${TOMCAT_WEBAPPS_DIR}"  "/app"

chmod -R g+rwX "$TOMCAT_HOME" "$TOMCAT_TMP_DIR" "$TOMCAT_LOG_DIR" "$TOMCAT_CONF_DIR" "$TOMCAT_WORK_DIR" "$TOMCAT_WEBAPPS_DIR"

touch "$TOMCAT_BIN_DIR/setenv.sh"
chmod g+rwX "$TOMCAT_BIN_DIR/setenv.sh"
