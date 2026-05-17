#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Environment variables
export OPENSEARCH_JAVA_HOME=/opt/bitnami/java
export OPENSEARCH_HOME=/opt/bitnami/opensearch
export OPENSEARCH_PATH_BIN="${OPENSEARCH_HOME}/bin"
export OPENSEARCH_PATH_CONF="${OPENSEARCH_HOME}/config"
export OPENSEARCH_PATH_PLUGINS="${OPENSEARCH_HOME}/plugins"
export OPENSEARCH_JAVA_OPTS="-Dopensearch.cgroups.hierarchy.override=/ ${OPENSEARCH_JAVA_OPTS:-}"

# Security Plugin
function setupSecurityPlugin {
    if [ -d "${OPENSEARCH_PATH_PLUGINS}/opensearch-security" ]; then
        if [ "${DISABLE_SECURITY_PLUGIN:-false}" = "true" ]; then
            echo "Disabling OpenSearch Security Plugin"
            opensearch_opt="-Eplugins.security.disabled=true"
            opensearch_opts+=("${opensearch_opt}")
        else
            echo "Enabling OpenSearch Security Plugin"
            if [ "${DISABLE_INSTALL_DEMO_CONFIG:-false}" = "true" ]; then
                echo "Disabling execution of install_demo_configuration.sh for OpenSearch Security Plugin"
            else
                echo "Enabling execution of install_demo_configuration.sh for OpenSearch Security Plugin"
                bash "${OPENSEARCH_PATH_PLUGINS}/opensearch-security/tools/install_demo_configuration.sh" -y -i -s || exit 1
            fi
        fi
    else
        echo "OpenSearch Security Plugin does not exist, disable by default"
    fi
}

# Performance Analyzer Plugin
function setupPerformanceAnalyzerPlugin {
    if [ -d "${OPENSEARCH_PATH_PLUGINS}/opensearch-performance-analyzer" ]; then
        if [ "${DISABLE_PERFORMANCE_ANALYZER_AGENT_CLI:-false}" = "true" ]; then
            echo "Disabling execution of ${OPENSEARCH_PATH_BIN}/opensearch-performance-analyzer/performance-analyzer-agent-cli for OpenSearch Performance Analyzer Plugin"
        else
            echo "Enabling execution of ${OPENSEARCH_PATH_BIN}/opensearch-performance-analyzer/performance-analyzer-agent-cli for OpenSearch Performance Analyzer Plugin"
            "${OPENSEARCH_PATH_BIN}/opensearch-performance-analyzer/performance-analyzer-agent-cli" > "${OPENSEARCH_HOME}/logs/PerformanceAnalyzer.log" 2>&1 & disown
        fi
    else
        echo "OpenSearch Performance Analyzer Plugin does not exist, disable by default"
    fi
}

# Start up the OpenSearch and Performance Analyzer agent processes.
# When either of them halts, this script exits, or we receive a SIGTERM or SIGINT signal then we want to kill both these processes.
function runOpenSearch {
    # Files created by OpenSearch should always be group writable too
    umask 0002

    if [[ "$(id -u)" == "0" ]]; then
        echo "OpenSearch cannot run as root. Please start your container as another user."
        exit 1
    fi

    # Parse Docker env vars to customize OpenSearch
    # e.g. Setting the env var cluster.name=testcluster
    # will cause OpenSearch to be invoked with -Ecluster.name=testcluster
    opensearch_opts=()
    while IFS='=' read -r envvar_key envvar_value
    do
        # OpenSearch settings need to have at least two dot separated lowercase
        # words, e.g. `cluster.name`, except for `processors` which we handle
        # specially
        if [[ "$envvar_key" =~ ^[a-z0-9_]+\.[a-z0-9_]+ || "$envvar_key" == "processors" ]]; then
            if [[ ! -z $envvar_value ]]; then
            opensearch_opt="-E${envvar_key}=${envvar_value}"
            opensearch_opts+=("${opensearch_opt}")
            fi
        fi
    done < <(env)

    setupSecurityPlugin
    setupPerformanceAnalyzerPlugin

    # Start opensearch
    exec "$@" "${opensearch_opts[@]}"
}

# Prepend "opensearch" command if no argument was provided or if the first
# argument looks like a flag (i.e. starts with a dash).
if [ $# -eq 0 ] || [ "${1:0:1}" = '-' ]; then
    set -- opensearch "$@"
fi

if [ "$1" = "opensearch" ]; then
    runOpenSearch "$@"
else
    exec "$@"
fi
