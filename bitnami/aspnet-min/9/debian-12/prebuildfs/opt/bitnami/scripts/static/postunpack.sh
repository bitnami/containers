#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091,SC1090,SC2034

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

DEST_DIR="/rootfs"

paths_to_mirror=(
    '/etc/debian_version'
    # Package 'netbase'
    '/etc/protocols'
    '/etc/services'
    '/etc/nsswitch.conf'
    # Package 'tzdata'
    '/etc/localtime'
    '/usr/share/zoneinfo'
    # Package 'ca-certificates'
    '/etc/ssl/certs/ca-certificates.crt'
    # System symlinks: /lib -> /usr/lib
    '/lib'
)

# Architecture-specific packages
case "$(uname -m)" in
x86_64)
    paths_to_mirror+=(
        # System symlinks: /lib64 -> /usr/lib64
        /lib64
    )
  ;;
esac

# Create '/usr/lib/os-release' and '/etc/os-release' files
mkdir -p "${DEST_DIR}/usr/lib"
cat <<EOF > "${DEST_DIR}/usr/lib/os-release"
PRETTY_NAME="Distroless"
NAME="Debian GNU/Linux"
ID="debian"
VERSION_ID="12"
VERSION="Debian GNU/Linux 12 (bookworm)"
ANSI_COLOR="1;34"
HOME_URL="https://www.vmware.com/products/app-platform/tanzu-application-catalog"
SUPPORT_URL="https://support.broadcom.com"
EOF


# shellcheck disable=SC1091

for file in "${paths_to_mirror[@]}"; do
    if [[ -d "$file" ]]; then
        dir="${DEST_DIR}$(dirname "$file")"
    else
        dir=$(dirname "${DEST_DIR}${file}")
    fi
    mkdir -p "$dir"
    cp -a "${file}" "$dir"
done

# /etc/os-release is a symlink to /usr/lib/os-release
ln -s /usr/lib/os-release "${DEST_DIR}/etc/os-release"

# Create '/etc/passwd', '/etc/group' and home directory
USER_NAME="${USER_NAME:-nonroot}"
GROUP_NAME="${GROUP_NAME:-nonroot}"
HOME_DIR="${HOME_DIR:-"/home/${USER_NAME}"}"

# Create the scratch root filesystem
mkdir -p "${DEST_DIR}${HOME_DIR}"
chown 65532:65532 "${DEST_DIR}${HOME_DIR}"

# Using rsync we copy only the empty folder while maintaining ownership and permissions from the original distro
rsync -av -f"+ var/" -f"- *" "/var" "/rootfs/var"
rsync -av -f"+ tmp/" -f"- *" "/tmp" "/rootfs/tmp"

cat <<EOF > "${DEST_DIR}/etc/group"
root:x:0:
daemon:x:6:
${GROUP_NAME}:x:65532:
EOF

cat <<EOF > "${DEST_DIR}/etc/passwd"
root:x:0:0:root:/root:/sbin/nologin
daemon:x:6:6:Daemon User:/dev/null:/bin/false
${USER_NAME}:x:65532:65532:${GROUP_NAME}:${HOME_DIR}:/sbin/nologin
EOF
