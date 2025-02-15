#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Discourse environment
. /opt/bitnami/scripts/discourse-env.sh

# Load libraries
. /opt/bitnami/scripts/libdiscourse.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Ensure the Discourse base directory exists and has proper permissions
info "Configuring file permissions for Discourse"
ensure_user_exists "$DISCOURSE_DAEMON_USER" --group "$DISCOURSE_DAEMON_GROUP" --system
# The backups and uploads directories are created at runtime after persistence logic, making it fail, so we create them here
declare -a writable_dirs=(
    # Skipping DISCOURSE BASE_DIR intentionally because it contains a lot of files/folders that should not be writable
    "$DISCOURSE_VOLUME_DIR"
    # Folders to persist
    "${DISCOURSE_BASE_DIR}/plugins"
    "${DISCOURSE_BASE_DIR}/public/backups"
    "${DISCOURSE_BASE_DIR}/public/uploads"
    # Folders that need to be writable for the app to work
    "${DISCOURSE_BASE_DIR}/app/assets"
    "${DISCOURSE_BASE_DIR}/log"
    "${DISCOURSE_BASE_DIR}/public"
    "${DISCOURSE_BASE_DIR}/tmp"
    "/home/${DISCOURSE_DAEMON_USER}"
    # Avoid Bundle usage warnings by creating a .bundler folder in the home directory
    "$(su "$DISCOURSE_DAEMON_USER" -s "$SHELL" -c "echo ~/.bundle")"
)
for dir in "${writable_dirs[@]}"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$DISCOURSE_DAEMON_USER" -g "root"
done

# Gem 'sprockets' purposely includes a broken symlink, which causes permissions change to fail
# We need to remove the broken symlink for chown to succeed
find "${DISCOURSE_BASE_DIR}/vendor/bundle/ruby" -wholename "*/sprockets-*/test/fixtures/errors/symlink" -type l -exec rm -f {} \;

# Add execution permissions to esbuild and ember binaries
chmod +x "${DISCOURSE_BASE_DIR}/node_modules/esbuild/bin/esbuild" "${DISCOURSE_BASE_DIR}/app/assets/javascripts/discourse/node_modules/ember-cli/bin/ember" "${DISCOURSE_BASE_DIR}/app/assets/javascripts/discourse/node_modules/.bin"/* "${DISCOURSE_BASE_DIR}/node_modules/.bin"/*

# HACK: The discourse source code is trying to access the deprecated Imagemagick "magick". In newer versions it was changed to "convert". Creating
# a symlink to avoid any issue
# https://github.com/discourse/discourse/blob/3f5b0dc98d0235adeea5b91c1656420418de6589/lib/upload_creator.rb#L421
ln -sf "$(which convert)" "/usr/bin/magick"
# Required for running as non-root users, for persistence logic to work properly
# Using g+rwx/g+rw instead of explicit 775/664 permissions because Discourse includes executable binaries in different subfolders
configure_permissions_ownership "$DISCOURSE_BASE_DIR" -d "g+rwx" -f "g+rw" -u "$DISCOURSE_DAEMON_USER" -g "root"
