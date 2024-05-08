#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami DokuWiki library

# shellcheck disable=SC1091
. /opt/bitnami/scripts/php-env.sh

# Load generic libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

########################
# Validate settings in DOKUWIKI_* env vars
# Globals:
#   DOKUWIKI_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
dokuwiki_validate() {
    debug "Validating settings in DOKUWIKI_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure DokuWiki is initialized
# Globals:
#   DOKUWIKI_*
# Arguments:
#   None
# Returns:
#   None
#########################
dokuwiki_initialize() {
    # Check if dokuwiki has already been initialized and persisted in a previous run
    local -r app_name="dokuwiki"
    if ! is_app_initialized "$app_name"; then
        # Ensure the DokuWikiWiki base directory exists and has proper permissions
        info "Configuring file permissions for DokuWiki"
        ensure_dir_exists "$DOKUWIKI_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$DOKUWIKI_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"

        if ! is_boolean_yes "${DOKUWIKI_SKIP_BOOTSTRAP:-}"; then
            web_server_start
            dokuwiki_pass_wizard
            web_server_stop
            dokuwiki_enable_friendly_urls
        fi

        info "Persisting DokuWiki installation"
        persist_app "$app_name" "$DOKUWIKI_DATA_TO_PERSIST"
    else
        info "Restoring persisted DokuWiki installation"
        restore_persisted_app "$app_name" "$DOKUWIKI_DATA_TO_PERSIST"
    fi
    dokuwiki_configure_DOKU_INC

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Pass Dokiwiki wizzard
# Globals:
#   DOKUWIKI_*
# Arguments:
#   None
# Returns:
#   None
#########################
dokuwiki_pass_wizard() {
    local -r port="${APACHE_HTTP_PORT_NUMBER:-"$APACHE_DEFAULT_HTTP_PORT_NUMBER"}"
    local wizard_url curl_output
    local -a curl_opts curl_data_opts
    wizard_url="http://127.0.0.1:${port}/install.php"
    curl_opts=("--location" "--silent")
    curl_data_opts=(
               "--data-urlencode" "l=en"
               "--data-urlencode" "d[acl]=on"
               "--data-urlencode" "d[policy]=0"
               "--data-urlencode" "d[allowreg]=on"
               "--data-urlencode" "d[license]=cc-by-sa"
               "--data-urlencode" "d[pop]=on"
               "--data-urlencode" "submit="
               "--data-urlencode" "d[title]=${DOKUWIKI_WIKI_NAME}"
               "--data-urlencode" "d[superuser]=${DOKUWIKI_USERNAME}"
               "--data-urlencode" "d[fullname]=${DOKUWIKI_FULL_NAME}"
               "--data-urlencode" "d[email]=${DOKUWIKI_EMAIL}"
               "--data-urlencode" "d[password]=${DOKUWIKI_PASSWORD}"
               "--data-urlencode" "d[confirm]=${DOKUWIKI_PASSWORD}"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}" 2>&1)"
    if [[ "$curl_output" != *"The configuration was finished successfully."* ]]; then
        error "An error occurred while installing DokuWiki"
        return 1
    fi
}

########################
# Enable DokuWiki friendly URLs
# Globals:
#   DOKUWIKI_*
# Arguments:
#   None
# Returns:
#   None
#########################
dokuwiki_enable_friendly_urls() {
    # Based on: https://www.dokuwiki.org/rewrite
    echo "\$conf['userewrite'] = 1; // URL rewriting is handled by the webserver" >>"${DOKUWIKI_BASE_DIR}/conf/local.php"
}

########################
# Configure DOKU_INC
# Globals:
#   DOKUWIKI_*
# Arguments:
#   None
# Returns:
#   None
#########################
dokuwiki_configure_DOKU_INC() {
    # Based on: https://github.com/bitnami/containers/pull/12535
    # Fix DOKU_INC, since we split application from state, DokuWiki's plugins and templates need to know where they live
    info "Fix DOKU_INC variable"
    auto_prepend_file="$DOKUWIKI_BASE_DIR/conf/auto_prepend.php"
    printf '<?php\ndefine("DOKU_INC", "%s/");\n' "$DOKUWIKI_BASE_DIR" >"$auto_prepend_file"
    php_conf_set auto_prepend_file "$auto_prepend_file"
}
