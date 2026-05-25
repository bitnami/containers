#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail

if [[ -z "${FABRIC_CA_SERVER_BOOTSTRAP_USER_PASS:-}" ]]; then
    echo "ERROR: FABRIC_CA_SERVER_BOOTSTRAP_USER_PASS is not set." >&2
    echo "Provide it as 'user:password' before starting the CA." >&2
    exit 1
fi

if [[ "${FABRIC_CA_SERVER_BOOTSTRAP_USER_PASS}" == "admin:adminpw" ]]; then
    echo "ERROR: FABRIC_CA_SERVER_BOOTSTRAP_USER_PASS is set to the publicly known default 'admin:adminpw'." >&2
    echo "Choose a unique strong password before deploying." >&2
    exit 1
fi

exec fabric-ca-server start -b "${FABRIC_CA_SERVER_BOOTSTRAP_USER_PASS}" "$@"
