#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libfile.sh

# Environment variables
export OPENSEARCH_JAVA_HOME=/opt/bitnami/java
export OPENSEARCH_DASHBOARDS_HOME=/opt/bitnami/opensearch-dashboards
export OPENSEARCH_DASHBOARDS_PATH_BIN="${OPENSEARCH_DASHBOARDS_HOME}/bin"
export OPENSEARCH_DASHBOARDS_PATH_CONF="${OPENSEARCH_DASHBOARDS_HOME}/config"
export OPENSEARCH_DASHBOARDS_PATH_PLUGINS="${OPENSEARCH_DASHBOARDS_HOME}/plugins"
export OPENSEARCH_DASHBOARDS_JAVA_OPTS="-Dopensearch.cgroups.hierarchy.override=/ ${OPENSEARCH_DASHBOARDS_JAVA_OPTS:-}"

opensearch_dashboards_vars=(
    console.enabled
    console.proxyConfig
    console.proxyFilter
    ops.cGroupOverrides.cpuPath
    ops.cGroupOverrides.cpuAcctPath
    cpu.cgroup.path.override
    cpuacct.cgroup.path.override
    csp.rules
    csp.strict
    csp.warnLegacyBrowsers
    data.search.usageTelemetry.enabled
    opensearch.customHeaders
    opensearch.hosts
    opensearch.logQueries
    opensearch.memoryCircuitBreaker.enabled
    opensearch.memoryCircuitBreaker.maxPercentage
    opensearch.password
    opensearch.pingTimeout
    opensearch.requestHeadersWhitelist
    opensearch.requestTimeout
    opensearch.shardTimeout
    opensearch.sniffInterval
    opensearch.sniffOnConnectionFault
    opensearch.sniffOnStart
    opensearch.ssl.alwaysPresentCertificate
    opensearch.ssl.certificate
    opensearch.ssl.certificateAuthorities
    opensearch.ssl.key
    opensearch.ssl.keyPassphrase
    opensearch.ssl.keystore.path
    opensearch.ssl.keystore.password
    opensearch.ssl.truststore.path
    opensearch.ssl.truststore.password
    opensearch.ssl.verificationMode
    opensearch.username
    i18n.locale
    interpreter.enableInVisualize
    opensearchDashboards.autocompleteTerminateAfter
    opensearchDashboards.autocompleteTimeout
    opensearchDashboards.defaultAppId
    opensearchDashboards.index
    logging.dest
    logging.ignoreEnospcError
    logging.json
    logging.quiet
    logging.rotate.enabled
    logging.rotate.everyBytes
    logging.rotate.keepFiles
    logging.rotate.pollingInterval
    logging.rotate.usePolling
    logging.silent
    logging.useUTC
    logging.verbose
    map.includeOpenSearchMapsService
    map.proxyOpenSearchMapsServiceInMaps
    map.regionmap
    map.tilemap.options.attribution
    map.tilemap.options.maxZoom
    map.tilemap.options.minZoom
    map.tilemap.options.subdomains
    map.tilemap.url
    monitoring.cluster_alerts.email_notifications.email_address
    monitoring.enabled
    monitoring.opensearchDashboards.collection.enabled
    monitoring.opensearchDashboards.collection.interval
    monitoring.ui.container.opensearch.enabled
    monitoring.ui.container.logstash.enabled
    monitoring.ui.opensearch.password
    monitoring.ui.opensearch.pingTimeout
    monitoring.ui.opensearch.hosts
    monitoring.ui.opensearch.username
    monitoring.ui.opensearch.logFetchCount
    monitoring.ui.opensearch.ssl.certificateAuthorities
    monitoring.ui.opensearch.ssl.verificationMode
    monitoring.ui.enabled
    monitoring.ui.max_bucket_size
    monitoring.ui.min_interval_seconds
    newsfeed.enabled
    ops.interval
    path.data
    pid.file
    regionmap
    security.showInsecureClusterWarning
    server.basePath
    server.customResponseHeaders
    server.compression.enabled
    server.compression.referrerWhitelist
    server.cors
    server.cors.origin
    server.defaultRoute
    server.host
    server.keepAliveTimeout
    server.maxPayloadBytes
    server.name
    server.port
    server.rewriteBasePath
    server.socketTimeout
    server.ssl.cert
    server.ssl.certificate
    server.ssl.certificateAuthorities
    server.ssl.cipherSuites
    server.ssl.clientAuthentication
    server.customResponseHeaders
    server.ssl.enabled
    server.ssl.key
    server.ssl.keyPassphrase
    server.ssl.keystore.path
    server.ssl.keystore.password
    server.ssl.truststore.path
    server.ssl.truststore.password
    server.ssl.redirectHttpFromPort
    server.ssl.supportedProtocols
    server.xsrf.disableProtection
    server.xsrf.whitelist
    status.allowAnonymous
    status.v6ApiFormat
    tilemap.options.attribution
    tilemap.options.maxZoom
    tilemap.options.minZoom
    tilemap.options.subdomains
    tilemap.url
    timeline.enabled
    vega.enableExternalUrls
    apm_oss.apmAgentConfigurationIndex
    apm_oss.indexPattern
    apm_oss.errorIndices
    apm_oss.onboardingIndices
    apm_oss.spanIndices
    apm_oss.sourcemapIndices
    apm_oss.transactionIndices
    apm_oss.metricsIndices
    telemetry.allowChangingOptInStatus
    telemetry.enabled
    telemetry.optIn
    telemetry.optInStatusUrl
    telemetry.sendUsageFrom
    vis_builder.enabled
    data_source.enabled
    data_source.encryption.wrappingKeyName
    data_source.encryption.wrappingKeyNamespace
    data_source.encryption.wrappingKey
    data_source.audit.enabled
    data_source.audit.appender.kind
    data_source.audit.appender.path
    data_source.audit.appender.layout.kind
    data_source.audit.appender.layout.highlight
    data_source.audit.appender.layout.pattern
    ml_commons_dashboards.enabled
    observability.query_assist.enabled
    usageCollection.uiMetric.enabled
    workspace.enabled
    assistant.chat.enabled
    assistant.alertInsight.enabled
    assistant.smartAnomalyDetector.enabled
    assistant.text2viz.enabled
    queryEnhancements.queryAssist.summary.enabled
    home.disableWelcomeScreen
    home.disableExperienceModal
    investigation.enabled
    investigation.agenticFeaturesEnabled
)

# Security Plugin
function setupSecurityDashboardsPlugin {
    if [ -d "${OPENSEARCH_DASHBOARDS_PATH_PLUGINS}/securityDashboards" ]; then
        if [ "${DISABLE_SECURITY_DASHBOARDS_PLUGIN:-false}" = "true" ]; then
            echo "Disabling OpenSearch Security Dashboards Plugin"
            "${OPENSEARCH_DASHBOARDS_PATH_BIN}/opensearch-dashboards-plugin" remove securityDashboards

            if [ -w "${OPENSEARCH_DASHBOARDS_PATH_CONF}/opensearch_dashboards.yml" ]; then
                replace_in_file "${OPENSEARCH_DASHBOARDS_PATH_CONF}/opensearch_dashboards.yml" "^opensearch_security" ""
                replace_in_file "${OPENSEARCH_DASHBOARDS_PATH_CONF}/opensearch_dashboards.yml" "https" "http"
            fi
        fi
    fi
}

function runOpenSearchDashboards {
    # Files created by OpenSearch Dashboards should always be group writable too
    umask 0002

    if [[ "$(id -u)" == "0" ]]; then
        echo "OpenSearch cannot run as root. Please start your container as another user."
        exit 1
    fi

    # Parse Docker env vars to customize OpenSearch Dashboards
    longopts=()
    for opensearch_dashboards_var in ${opensearch_dashboards_vars[*]}; do
        env_var=$(echo ${opensearch_dashboards_var^^} | tr . _)
        value=${!env_var:-}
        if [[ -n $value ]]; then
            longopt="--${opensearch_dashboards_var}=${value}"
            longopts+=("${longopt}")
        fi
    done

    setupSecurityDashboardsPlugin

    # Start opensearch dashboards
    exec "$@" "${longopts[@]}"
}

# Prepend "opensearch-dashboards" command if no argument was provided or if the first
# argument looks like a flag (i.e. starts with a dash).
if [ $# -eq 0 ] || [ "${1:0:1}" = '-' ]; then
    set -- opensearch-dashboards "$@"
fi

if [ "$1" = "opensearch-dashboards" ]; then
    runOpenSearchDashboards "$@"
else
    exec "$@"
fi
