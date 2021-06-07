#!/bin/bash

grafana_install_plugin_command="/opt/bitnami/grafana/bin/grafana-cli"
grafana_install_plugin_args=("--pluginsDir" "/opt/bitnami/grafana/data/plugins" "plugins" "install")
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
  echo Installing "$plugin"
  "${grafana_install_plugin_command[@]}" "${grafana_install_plugin_args[@]}" "${plugin}"
done
chmod g+rwX /opt/bitnami/grafana/data/plugins

# The Grafana Helm chart mounts the data directory at "/opt/bitnami/grafana/data"
# Therefore, all the plugins installed when building the image will be lost
# As a workaround, we can move them to a "default-plugins" directory and recover them
# during the 1st boot of the container
mkdir -p /opt/bitnami/grafana/default-plugins
mv /opt/bitnami/grafana/data/plugins/* /opt/bitnami/grafana/default-plugins/
