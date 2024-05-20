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
    "grafana-piechart-panel"
    "michaeldmoore-annunciator-panel"
    "briangann-gauge-panel"
    "briangann-datatable-panel"
    "jdbranham-diagram-panel"
    "natel-discrete-panel"
    "digiapulssi-organisations-panel"
    "vonage-status-panel"
    "neocat-cal-heatmap-panel"
    "agenty-flowcharting-panel"
    "larona-epict-panel"
    "pierosavi-imageit-panel"
    "michaeldmoore-multistat-panel"
    "grafana-polystat-panel"
    "scadavis-synoptic-panel"
    "marcuscalidus-svg-panel"
    "snuids-trafficlights-panel"
)
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
