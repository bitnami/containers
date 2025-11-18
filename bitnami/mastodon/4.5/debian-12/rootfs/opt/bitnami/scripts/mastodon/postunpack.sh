#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libmastodon.sh

# Load Mastodon environment variables
. /opt/bitnami/scripts/mastodon-env.sh

# System User
ensure_user_exists "$MASTODON_DAEMON_USER" --group "$MASTODON_DAEMON_GROUP" --home "/home/${MASTODON_DAEMON_USER}" --system

for dir in "$MASTODON_VOLUME_DIR" "$MASTODON_TMP_DIR" "$MASTODON_SYSTEM_DIR" "$MASTODON_ASSETS_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -g "root"
done

# We need to give write permissions to the public folder so we can persist the system and assets folders
chmod g+rwX "${MASTODON_BASE_DIR}/public"

# HACK: In order to allow accessing from different hosts and to enable/disable HTTPS in
# production mode, we need to change some Rails configuration files
# https://github.com/mastodon/mastodon/blob/main/config/initializers/1_hosts.rb#L33
# https://github.com/mastodon/mastodon/blob/main/config/environments/production.rb#L47

# Make HTTPS mode depend on an environment variable and not the RAILS_ENV
replace_in_file "${MASTODON_BASE_DIR}/config/initializers/1_hosts.rb" "https = Rails.env.production[?]" "https = ENV['MASTODON_HTTPS_ENABLED'] == 'true'"

# Clear authorized hosts array when MASTODON_ALLOW_ALL_DOMAINS is set to true
replace_in_file "${MASTODON_BASE_DIR}/config/initializers/1_hosts.rb" "config.host_authorization" "config.hosts.clear if ENV['MASTODON_ALLOW_ALL_DOMAINS'] == 'true'\n    config.host_authorization"

# Make HTTPS forced redirect to depend on the MASTODON_HTTPS_ENABLED variable
replace_in_file "${MASTODON_BASE_DIR}/config/environments/production.rb" "config.force_ssl = true" "config.force_ssl = ENV['MASTODON_HTTPS_ENABLED'] == 'true'"

# Add symlinks to the default paths to make a similar UX as the upstream Mastodon container
# https://github.com/mastodonorg/mastodon/blob/release/Dockerfile#L6
ln -s "${MASTODON_BASE_DIR}" "/opt/mastodon"
