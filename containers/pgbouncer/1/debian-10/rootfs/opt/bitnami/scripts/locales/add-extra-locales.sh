#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Defaults
WITH_ALL_LOCALES="${WITH_ALL_LOCALES:-no}"
EXTRA_LOCALES="${EXTRA_LOCALES:-}"

# Constants
LOCALES_FILE="/etc/locale.gen"
SUPPORTED_LOCALES_FILE="/usr/share/i18n/SUPPORTED"

# Helper function for enabling locale only when it was not added before
enable_locale() {
    local -r locale="${1:?missing locale}"
    if ! grep -q -E "^${locale}$" "$SUPPORTED_LOCALES_FILE"; then
        echo "Locale ${locale} is not supported in this system"
        return 1
    fi
    if ! grep -q -E "^${locale}" "$LOCALES_FILE"; then
        echo "$locale" >> "$LOCALES_FILE"
    else
        echo "Locale ${locale} is already enabled"
    fi
}

if [[ "$WITH_ALL_LOCALES" =~ ^(yes|true|1)$ ]]; then
    echo "Enabling all locales"
    cp "$SUPPORTED_LOCALES_FILE" "$LOCALES_FILE"
else
    LOCALES_TO_ADD="$(sed 's/[,;]\s*/\n/g' <<< "$EXTRA_LOCALES")"
    while [[ -n "$LOCALES_TO_ADD" ]] && read -r locale; do
        echo "Enabling locale ${locale}"
        enable_locale "$locale"
    done <<< "$LOCALES_TO_ADD"
fi

locale-gen
