#!/bin/sh

set -e

if ! command -v openssl &>/dev/null; then
  echo "openssl could not be found"
  exit 1
fi

function fips_enabled() {
  openssl list -providers | grep -qwF fips
}

function print_fips_state() {
  if fips_enabled; then
    echo "FIPS mode is enabled"
  else
    echo "FIPS mode is disabled"
  fi
}

print_fips_state

set +e
