#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load WP-CLI environment
. /opt/bitnami/scripts/wp-cli-env.sh

# Load PHP environment for WP-CLI templates (after 'wp-cli-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Ensure the WordPress base directory exists and has proper permissions
info "Configuring file permissions for WP-CLI"
ensure_user_exists "$WP_CLI_DAEMON_USER" --group "$WP_CLI_DAEMON_GROUP"
declare -a writable_dirs=(
    "${WP_CLI_BASE_DIR}/.cache" "${WP_CLI_BASE_DIR}/.packages"
)
for dir in "${writable_dirs[@]}"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "g+rwx" -f "g+rw" -u "$WP_CLI_DAEMON_USER" -g "root"
done

# Configure wp-cli
ensure_dir_exists "$WP_CLI_CONF_DIR"
cat >"$WP_CLI_CONF_FILE" <<EOF
# Global parameter defaults
path: "${BITNAMI_ROOT_DIR}/wordpress"
EOF
render-template "${BITNAMI_ROOT_DIR}/scripts/wp-cli/bitnami-templates/wp.tpl" >"${WP_CLI_BIN_DIR}/wp"
configure_permissions_ownership "${WP_CLI_BIN_DIR}/wp" -f "755"
