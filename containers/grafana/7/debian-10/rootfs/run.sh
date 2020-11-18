#!/bin/bash -e

# shellcheck disable=SC2034

: "${GF_PATHS_CONFIG:=/opt/bitnami/grafana/conf/grafana.ini}"
: "${GF_PATHS_DATA:=/opt/bitnami/grafana/data}"
: "${GF_PATHS_LOGS:=/opt/bitnami/grafana/logs}"
: "${GF_PATHS_PLUGINS:=/opt/bitnami/grafana/data/plugins}"
: "${GF_PATHS_DEFAULT_PLUGINS:=/opt/bitnami/grafana/default-plugins}"
: "${GF_PATHS_PROVISIONING:=/opt/bitnami/grafana/conf/provisioning}"

# Ensure compatibility with the Grafana Operator
grafana_operator_compatibility() {
    # Based on https://github.com/integr8ly/grafana-operator/tree/master/pkg/controller/config/controller_config.go
    local -r GF_OP_PATHS_CONFIG='/etc/grafana/grafana.ini'
    local -r GF_OP_PATHS_DATA='/var/lib/grafana'
    local -r GF_OP_PATHS_LOGS='/var/log/grafana'
    local -r GF_OP_PATHS_PROVISIONING='/etc/grafana/provisioning'

    local -a path_suffixes=('config' 'data' 'logs' 'provisioning')

    for suffix in "${path_suffixes[@]}"; do
        local gf_op_var="GF_OP_PATHS_${suffix^^}"
        local gf_var="GF_PATHS_${suffix^^}"

        if [[ -e "${!gf_op_var}" ]] && [[ "${!gf_op_var}" != "${!gf_var}" ]]; then
            echo "Ensuring '${!gf_var}' points to '${!gf_op_var}'"
            rm -rf "${!gf_var}"
            ln -sfn "${!gf_op_var}" "${!gf_var}"
        fi
    done
}

# Use operator-compatible environment variable to install plugins. Useful to use the image as initContainer
grafana_operator_plugins_init() {
    # Based on https://github.com/integr8ly/grafana-operator/blob/master/pkg/controller/grafana/pluginsHelper.go
    local -r GF_OP_PLUGINS_INIT_DIR='/opt/plugins'
    if [[ -d "$GF_OP_PLUGINS_INIT_DIR" ]]; then
        echo "Detected '${GF_OP_PLUGINS_INIT_DIR}' dir. The container will run as grafana-operator plugins init"
        if [[ -n "$GRAFANA_PLUGINS" ]]; then
            export GF_INSTALL_PLUGINS="$GRAFANA_PLUGINS"
            export GF_PATHS_PLUGINS="$GF_OP_PLUGINS_INIT_DIR"
            grafana_install_plugins
        fi
        exit 0
    fi
}

# Recover plugins installed when building the image
grafana_recover_default_plugins() {
    if [[ ! -e "$GF_PATHS_PLUGINS" ]] || [[ -z "$(ls -A "$GF_PATHS_PLUGINS")" ]]; then
        mkdir -p "$GF_PATHS_PLUGINS"
        if [[ -e "$GF_PATHS_DEFAULT_PLUGINS" ]] && [[ -n "$(ls -A "$GF_PATHS_DEFAULT_PLUGINS")" ]]; then
            cp -r "$GF_PATHS_DEFAULT_PLUGINS"/* "$GF_PATHS_PLUGINS"
        fi
    fi
}

# Install plugins
grafana_install_plugins() {
    if [[ -n "$GF_INSTALL_PLUGINS" ]]; then
        splitted_plugin_list=$(tr ',;' ' ' <<< "${GF_INSTALL_PLUGINS}")
        read -r -a gf_plugins_list <<< "$splitted_plugin_list"
        for plugin in "${gf_plugins_list[@]}"; do
            grafana_install_plugin_args=("--pluginsDir" "$GF_PATHS_PLUGINS")
            plugin_id="$plugin"
            plugin_version=""
            if echo "$plugin" | grep "=" > /dev/null 2>&1; then
                splitted_plugin_entry=$(tr '=' ' ' <<< "${plugin}")
                read -r -a plugin_url_array <<< "$splitted_plugin_entry"
                echo "Installing plugin with id ${plugin_url_array[0]} and url ${plugin_url_array[1]}"
                plugin_id="${plugin_url_array[0]}"
                grafana_install_plugin_args+=("--pluginUrl" "${plugin_url_array[1]}")
            elif echo "$plugin" | grep ":" > /dev/null 2>&1; then
                splitted_plugin_entry=$(tr ':' ' ' <<< "${plugin}")
                read -r -a plugin_id_version_array <<< "$splitted_plugin_entry"
                plugin_id="${plugin_id_version_array[0]}"
                plugin_version="${plugin_id_version_array[1]}"
                echo "Installing plugin ${plugin_id} @ ${plugin_version}"
            else
                echo "Installing plugin with id ${plugin_id}"
            fi
            if [[ "${GF_INSTALL_PLUGINS_SKIP_TLS:-}" = "yes" ]]; then
                grafana_install_plugin_args+=("--insecure")
            fi
            grafana_install_plugin_args+=("plugins" "install" "${plugin_id}")
            if [[ -n "$plugin_version" ]]; then
                grafana_install_plugin_args+=("$plugin_version")
            fi
            grafana-cli "${grafana_install_plugin_args[@]}"
        done
    fi
}

grafana_operator_compatibility
grafana_operator_plugins_init
grafana_recover_default_plugins
grafana_install_plugins

exec /opt/bitnami/grafana/bin/grafana-server                 \
     --homepath=/opt/bitnami/grafana/                        \
     --config="$GF_PATHS_CONFIG"                             \
     cfg:default.log.mode="console"                          \
     cfg:default.paths.data="$GF_PATHS_DATA"                 \
     cfg:default.paths.logs="$GF_PATHS_LOGS"                 \
     cfg:default.paths.plugins="$GF_PATHS_PLUGINS"           \
     cfg:default.paths.provisioning="$GF_PATHS_PROVISIONING" \
     "$@"
