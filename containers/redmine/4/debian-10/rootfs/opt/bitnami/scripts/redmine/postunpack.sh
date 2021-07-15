#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Redmine environment
. /opt/bitnami/scripts/redmine-env.sh

# Load libraries
. /opt/bitnami/scripts/libredmine.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Enable Redmine configuration file
[[ ! -f "${REDMINE_CONF_DIR}/configuration.yml" ]] && cp "${REDMINE_CONF_DIR}/configuration.yml.example" "${REDMINE_CONF_DIR}/configuration.yml"

# Ensure the Redmine base directory exists and has proper permissions
info "Configuring file permissions for Redmine"
ensure_user_exists "$REDMINE_DAEMON_USER" --group "$REDMINE_DAEMON_GROUP" --system
declare -a writable_dirs=(
    # Skipping REDMINE_BASE_DIR intentionally because it contains a lot of files/folders that should not be writable
    "$REDMINE_VOLUME_DIR"
    # Folders to persist
    "${REDMINE_BASE_DIR}/files"
    "${REDMINE_BASE_DIR}/plugins"
    "${REDMINE_BASE_DIR}/public/plugin_assets"
    # Folders that need to be writable for the app to work
    "${REDMINE_BASE_DIR}/log"
    "${REDMINE_BASE_DIR}/tmp"
    # Config needs to be writable for actions to update things like tokens or DB credentials
    "${REDMINE_BASE_DIR}/config"
    # Redmine creates 'db/schema.rb' file after executing migrations
    "${REDMINE_BASE_DIR}/db"
    # Avoid Bundle usage warnings by creating a .bundler folder in the home directory
    "$(su "$REDMINE_DAEMON_USER" -s "$SHELL" -c "echo ~/.bundle")"
)
for dir in "${writable_dirs[@]}"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$REDMINE_DAEMON_USER" -g "root"
done

# Required for running as non-root users, for persistence logic to work properly
# Using g+rwx/g+rw instead of explicit 775/664 permissions because Redmine includes executable binaries in different subfolders
configure_permissions_ownership "$REDMINE_BASE_DIR" -d "g+rwx" -f "g+rw" -u "$REDMINE_DAEMON_USER" -g "root"
