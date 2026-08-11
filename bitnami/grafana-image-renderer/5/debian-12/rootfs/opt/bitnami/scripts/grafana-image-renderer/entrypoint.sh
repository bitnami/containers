#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail

export HOME="/opt/bitnami/grafana-image-renderer"

if [[ -n "${CA_CERTIFICATES_PATH:-}" ]] && [[ -f "${CA_CERTIFICATES_PATH}" ]]; then
    echo "Adding custom CA certificate to NSS database..."
    mkdir -p "$HOME/.pki/nssdb"
    certutil -d sql:"$HOME/.pki/nssdb" -N --empty-password
    certutil -d sql:"$HOME/.pki/nssdb" -A -t "C,," -n custom-ca -i "${CA_CERTIFICATES_PATH}"
fi

exec grafana-image-renderer "$@"