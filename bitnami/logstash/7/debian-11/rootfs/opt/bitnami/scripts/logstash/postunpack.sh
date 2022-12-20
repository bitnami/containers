#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblogstash.sh

# Load Logstash environment variables
. /opt/bitnami/scripts/logstash-env.sh

info "Creating Logstash daemon user"
ensure_user_exists "$LOGSTASH_DAEMON_USER" --group "$LOGSTASH_DAEMON_GROUP"

for dir in "$LOGSTASH_BASE_DIR/vendor/bundle/jruby" "$LOGSTASH_CONF_DIR" "$LOGSTASH_PIPELINE_CONF_DIR" "$LOGSTASH_MOUNTED_CONF_DIR" "$LOGSTASH_MOUNTED_PIPELINE_CONF_DIR" "$LOGSTASH_VOLUME_DIR" "$LOGSTASH_DATA_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$LOGSTASH_DAEMON_USER" -g "root"
done

for file in "$LOGSTASH_BASE_DIR/Gemfile" "$LOGSTASH_BASE_DIR/Gemfile.lock"; do
    configure_permissions_ownership "$file" -f "664" -u "$LOGSTASH_DAEMON_USER" -g "root"
done

info "Configuring paths"
logstash_yml_set "$LOGSTASH_CONF_FILE" '"path.data"' "$LOGSTASH_DATA_DIR"

info "Configuring logging to standard output"
# Back up the original file for users who'd like to use logfile logging
cp -L "${LOGSTASH_CONF_DIR}/log4j2.properties" "${LOGSTASH_CONF_DIR}/log4j2.orig.properties"
cat > "${LOGSTASH_CONF_DIR}/log4j2.properties" << EOF
status = error
name = LogstashPropertiesConfig

appender.console.type = Console
appender.console.name = plain_console
appender.console.layout.type = PatternLayout
appender.console.layout.pattern = [%d{ISO8601}][%-5p][%-25c]%notEmpty{[%X{pipeline.id}]}%notEmpty{[%X{plugin.id}]} %m%n

appender.json_console.type = Console
appender.json_console.name = json_console
appender.json_console.layout.type = JSONLayout
appender.json_console.layout.compact = true
appender.json_console.layout.eventEol = true

rootLogger.level = \${sys:ls.log.level}
rootLogger.appenderRef.console.ref = \${sys:ls.log.format}_console
EOF

logstash_install_plugins
