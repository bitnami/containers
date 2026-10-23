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

# A reused Mastodon component can contain native gems linked to an older Photon ICU ABI.
# Rebuild the affected gem against the final image's ICU, before dropping build dependencies.
if [[ "$(get_os_metadata --id)" == "photon" ]]; then
    while IFS= read -r extension; do
        linkage="$(ldd "$extension")"
        if ! grep -Eq 'libicu[^[:space:]]* => not found' <<< "$linkage"; then
            continue
        fi

        info "Rebuilding charlock_holmes against the installed Photon ICU"
        gem_dir="${extension%/lib/charlock_holmes/charlock_holmes.so}"
        gem_name="${gem_dir##*/}"
        build_dir="$(mktemp -d)"
        tdnf list installed | awk '/\.(aarch64|x86_64|noarch)[[:space:]]/ {sub(/\.[^.]+$/, "", $1); print $1}' | sort -u > "${build_dir}/packages-before"
        install_packages binutils gcc glibc-devel linux-api-headers make icu-devel jemalloc-devel zlib-devel
        tdnf list installed | awk '/\.(aarch64|x86_64|noarch)[[:space:]]/ {sub(/\.[^.]+$/, "", $1); print $1}' | sort -u > "${build_dir}/packages-after"

        cp -a "${gem_dir}/ext/charlock_holmes/." "${build_dir}/"
        (
            cd "$build_dir"
            /opt/bitnami/ruby/bin/ruby extconf.rb
            make
        )
        # Bundler and direct Ruby requires can load different copies of the same extension.
        find "${MASTODON_BASE_DIR}/vendor/bundle/ruby" -type f \
            \( -path "*/gems/${gem_name}/lib/charlock_holmes/charlock_holmes.so" \
            -o -path "*/extensions/*/*/${gem_name}/charlock_holmes/charlock_holmes.so" \) \
            -exec cp "${build_dir}/charlock_holmes.so" {} \;

        mapfile -t build_packages < <(comm -13 "${build_dir}/packages-before" "${build_dir}/packages-after")
        if [[ "${#build_packages[@]}" -gt 0 ]]; then
            uninstall_packages --noautoremove "${build_packages[@]}"
        fi
        rm -rf "$build_dir"
        /opt/bitnami/ruby/bin/ruby -I "${gem_dir}/lib" -r charlock_holmes -e 'exit 0'
    done < <(find "${MASTODON_BASE_DIR}/vendor/bundle/ruby" -type f \
        -path '*/gems/charlock_holmes-*/lib/charlock_holmes/charlock_holmes.so')
fi

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
