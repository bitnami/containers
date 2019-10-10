#!/bin/bash -e

: "${GF_PATHS_CONFIG:=/opt/bitnami/grafana/conf/grafana.ini}"
: "${GF_PATHS_DATA:=/opt/bitnami/grafana/data}"
: "${GF_PATHS_LOGS:=/opt/bitnami/grafana/logs}"
: "${GF_PATHS_PLUGINS:=/opt/bitnami/grafana/data/plugins}"
: "${GF_PATHS_PROVISIONING:=/opt/bitnami/grafana/conf/provisioning}"

if [[ -n "$GF_INSTALL_PLUGINS" ]]; then
    splitted_plugin_list=$(tr ',;' ' ' <<< "${GF_INSTALL_PLUGINS}")
    read -r -a gf_plugins_list <<< "$splitted_plugin_list"
    for plugin in "${gf_plugins_list[@]}"; do
        grafana_install_plugin_args=("--pluginsDir" "$GF_PATHS_PLUGINS")
        plugin_id="$plugin"
        if echo "$plugin" | grep "=" > /dev/null 2>&1; then
            splitted_plugin_entry=$(tr '=' ' ' <<< "${plugin}")
            read -r -a plugin_url_array <<< "$splitted_plugin_entry"
            echo "Installing plugin with id ${plugin_url_array[0]} and url ${plugin_url_array[1]}"
            plugin_id="${plugin_url_array[0]}"
            grafana_install_plugin_args+=("--pluginUrl" "${plugin_url_array[1]}")
        else
            echo "Installing plugin with id ${plugin_id}"
        fi
        if [[ "${GF_INSTALL_PLUGINS_SKIP_TLS:-}" = "yes" ]]; then
            grafana_install_plugin_args+=("--insecure")
        fi
        grafana_install_plugin_args+=("plugins" "install" "${plugin_id}")
        grafana-cli "${grafana_install_plugin_args[@]}"
    done
fi

exec /opt/bitnami/grafana/bin/grafana-server                 \
     --homepath=/opt/bitnami/grafana/                        \
     --config="$GF_PATHS_CONFIG"                             \
     cfg:default.log.mode="console"                          \
     cfg:default.paths.data="$GF_PATHS_DATA"                 \
     cfg:default.paths.logs="$GF_PATHS_LOGS"                 \
     cfg:default.paths.plugins="$GF_PATHS_PLUGINS"           \
     cfg:default.paths.provisioning="$GF_PATHS_PROVISIONING" \
     "$@"
