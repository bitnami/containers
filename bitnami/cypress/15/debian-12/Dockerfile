# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-09-28T18:22:53Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/cypress/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/cypress" \
      org.opencontainers.image.title="cypress" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="15.3.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates chromium curl libasound2 libavahi-client3 libavahi-common3 libblkid1 libbsd0 libbz2-1.0 libcap2 libcom-err2 libcups2 libdbus-1-3 libexpat1 libffi8 libgbm-dev libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libgtk-3-0 libgtk2.0-0 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblz4-1 liblzma5 libmd0 libmount1 libncursesw6 libnettle8 libnotify-dev libnss3 libp11-kit0 libpcre2-8-0 libreadline8 libselinux1 libsqlite3-0 libssl3 libstdc++6 libsystemd0 libtasn1-6 libtinfo6 libudev1 libunistring2 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxss1 libxtst6 libzstd1 procps xauth xvfb zlib1g
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "python-3.13.7-2-linux-${OS_ARCH}-debian-12" \
      "node-24.9.0-0-linux-${OS_ARCH}-debian-12" \
      "cypress-15.3.0-0-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root cypress
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN mkdir /.local && chmod g+rwX /.local
RUN uninstall_packages curl

RUN mkdir /app && chmod g+rwX -R /app /opt/bitnami/node/cypress-cache && ln -s /app /e2e && mkdir -p /usr/local/lib /usr/local/bin && ln -s /opt/bitnami/node/node_modules /usr/local/lib/node_modules && ln -s /usr/local/lib/node_modules/cypress/bin/cypress /usr/local/bin/cypress && mkdir -p /.pki /.local /.config /.cache /.fontconfig && chmod g+rwX -R /.pki /.local /.cache /.config /.fontconfig
ENV APP_VERSION="15.3.0" \
    BITNAMI_APP_NAME="cypress" \
    CYPRESS_CACHE_FOLDER="/opt/bitnami/node/cypress-cache" \
    IMAGE_REVISION="8" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/node/lib/node_modules/cypress/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "cypress" ]
