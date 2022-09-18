#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load JasperReports environment
. /opt/bitnami/scripts/jasperreports-env.sh

# Load libraries
. /opt/bitnami/scripts/libjasperreports.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Copy and configure configuration file
cp "${JASPERREPORTS_CONF_DIR}/sample_conf/mysql_master.properties" "$JASPERREPORTS_CONF_FILE"

# Delete duplicate example MySQL configuration lines in the configuration file so it does not break the jasperreports_conf_set function
remove_in_file "$JASPERREPORTS_CONF_FILE" "jdbcDriverClass=com.mysql.*"
remove_in_file "$JASPERREPORTS_CONF_FILE" "jdbcDataSourceClass=com.mysql"
remove_in_file "$JASPERREPORTS_CONF_FILE" "maven.jdbc.groupId=mysql"
remove_in_file "$JASPERREPORTS_CONF_FILE" "maven.jdbc.artifactId=mysql.*"
remove_in_file "$JASPERREPORTS_CONF_FILE" "maven.jdbc.version=.*bin"
remove_in_file "$JASPERREPORTS_CONF_FILE" "# appServerDir"

# Configure default MariaDB settings
jasperreports_conf_set "jdbcDriverClass" "org.mariadb.jdbc.Driver"
jasperreports_conf_set "jdbcDataSourceClass" "org.mariadb.jdbc.MySQLDataSource"
jasperreports_conf_set "maven.jdbc.groupId" "org.mariadb.jdbc"
jasperreports_conf_set "maven.jdbc.artifactId" "mariadb-java-client"
jasperreports_conf_set "dbPassword" ""

# Configure Tomcat path
jasperreports_conf_set "appServerDir" "${BITNAMI_ROOT_DIR}/tomcat"

# Set keystore location (based on https://community.jaspersoft.com/wiki/encryption-jasperreports-server-75)
cat <<EOF >"${JASPERREPORTS_CONF_DIR}/keystore.init.properties"
ks=${JASPERREPORTS_BASE_DIR}
ksp=${JASPERREPORTS_BASE_DIR}
EOF

# Ensure the JasperReports base directory exists and has proper permissions
info "Configuring file permissions for JasperReports"
ensure_user_exists "$JASPERREPORTS_DAEMON_USER" --group "$JASPERREPORTS_DAEMON_GROUP" --system
for dir in "$JASPERREPORTS_BASE_DIR" "$JASPERREPORTS_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$JASPERREPORTS_DAEMON_USER" -g "root"
done

# Disable variable that deletes the JASPERREPORTS_BASE_DIR folder when deploying the war file
xmlstarlet ed -L -d '//var[@name="warTargetDirDel"]' "${JASPERREPORTS_CONF_DIR}/bin/app-server.xml"

# Grant execution permissions to the buildomatic and ant scripts
chmod +x "$JASPERREPORTS_CONF_DIR"/*.sh "$JASPERREPORTS_CONF_DIR"/bin/*.sh "$JASPERREPORTS_CONF_DIR"/js-ant "$JASPERREPORTS_CONF_DIR"/js-mvn "${JASPERREPORTS_BASE_DIR}/apache-ant/bin/ant" "${JASPERREPORTS_BASE_DIR}/apache-ant/bin/antRun"
