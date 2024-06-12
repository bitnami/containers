#!/bin/bash

set -e

if ! command -v openssl &>/dev/null; then
  echo "openssl could not be found"
  exit 1
fi

OPENSSL_DIR=$(openssl version -d | sed -n 's/.*"\(.*\)"/\1/p')

fips-mode-setup --enable --no-bootcfg

# We should be using openssl fipsinstall but it is disabled on UBI9
cat <<EOF >>"${OPENSSL_DIR}/openssl_fips.cnf"

[openssl_init]
providers = provider_sect


[provider_sect]
fips = fips_sect

[fips_sect]
activate = 1

[default_sect]
activate = 0

[default]
.include /etc/pki/tls/openssl.cnf
EOF

set +e
