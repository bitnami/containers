#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Grafana environment
. /opt/bitnami/scripts/grafana-env.sh

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libgrafana.sh

info "Creating configuration file"
cp "${GRAFANA_BASE_DIR}/conf/sample.ini" "$(grafana_env_var_value PATHS_CONFIG)"

info "Creating system user"
ensure_user_exists "$GRAFANA_DAEMON_USER" --group "$GRAFANA_DAEMON_GROUP" --system

info "Configuring file permissions"
for dir in "$(grafana_env_var_value PATHS_DATA)" "$(grafana_env_var_value PATHS_LOGS)" "$(grafana_env_var_value PATHS_PLUGINS)" "$(grafana_env_var_value PATHS_PROVISIONING)" "$(grafana_env_var_value VOLUME_DIR)" "${GRAFANA_DEFAULT_CONF_DIR}"; do
    ensure_dir_exists "$dir"
    # Use grafana:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$GRAFANA_DAEMON_USER" -g "root"
done

# Use grafana:root ownership for compatibility when running as a non-root user
configure_permissions_ownership "$(grafana_env_var_value PATHS_CONFIG)" -f "664" -u "$GRAFANA_DAEMON_USER" -g "root"

# Ensure permissions to parent directories of configs
# Used when replacing configs with symlinks for grafana-operator compatibility
for dir in "$(grafana_env_var_value PATHS_CONFIG)" "$(grafana_env_var_value PATHS_DATA)" "$(grafana_env_var_value PATHS_LOGS)" "$(grafana_env_var_value PATHS_PROVISIONING)"; do
    chmod 775 "$(dirname "$dir")"
done

# Install well-known plugins
grafana_plugin_list=(
    "grafana-clock-panel"
    "briangann-gauge-panel"
    "jdbranham-diagram-panel"
    "vonage-status-panel"
    "larona-epict-panel"
    "pierosavi-imageit-panel"
    "grafana-polystat-panel"
    "scadavis-synoptic-panel"
)

# Plugins deprecated in version 11 but still valid in version 10
grafana_10_plugin_list=(
    "grafana-piechart-panel"
    "michaeldmoore-annunciator-panel"
    "briangann-datatable-panel"
    "natel-discrete-panel"
    "digiapulssi-organisations-panel"
    "neocat-cal-heatmap-panel"
    "agenty-flowcharting-panel"
    "michaeldmoore-multistat-panel"
    "marcuscalidus-svg-panel"
    "snuids-trafficlights-panel"
)

if [[ "$(get_grafana_major_version)" -le 10 ]]; then
    grafana_plugin_list+=( "${grafana_10_plugin_list[@]}" )
fi

cd ${GRAFANA_BASE_DIR} || exit 1
for plugin in "${grafana_plugin_list[@]}"; do
    info "Installing ${plugin} plugin"
    grafana cli --pluginsDir "$(grafana_env_var_value PATHS_PLUGINS)" plugins install "$plugin"
done

# The Grafana Helm chart mounts the data directory at "/opt/bitnami/grafana/data"
# Therefore, all the plugins installed when building the image will be lost
# As a workaround, we can move them to a "default-plugins" directory and recover them
# during the 1st boot of the container
ensure_dir_exists "$GRAFANA_DEFAULT_PLUGINS_DIR"
mv "$(grafana_env_var_value PATHS_PLUGINS)"/* "$GRAFANA_DEFAULT_PLUGINS_DIR"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "$GRAFANA_CONF_DIR"/* "$GRAFANA_DEFAULT_CONF_DIR"
