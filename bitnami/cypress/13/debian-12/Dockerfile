# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2024-05-29T06:46:16Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/cypress/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="13.10.0-debian-12-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/cypress" \
      org.opencontainers.image.title="cypress" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="13.10.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates chromium curl libasound2 libavahi-client3 libavahi-common3 libblkid1 libbsd0 libbz2-1.0 libcap2 libcom-err2 libcrypt1 libcups2 libdbus-1-3 libexpat1 libffi8 libgbm-dev libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libgtk-3-0 libgtk2.0-0 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblz4-1 liblzma5 libmd0 libmount1 libncursesw6 libnettle8 libnotify-dev libnsl2 libnss3 libp11-kit0 libpcre2-8-0 libreadline8 libselinux1 libsqlite3-0 libssl3 libstdc++6 libsystemd0 libtasn1-6 libtinfo6 libtirpc3 libunistring2 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxss1 libxtst6 libzstd1 procps xauth xvfb zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "python-3.11.9-10-linux-${OS_ARCH}-debian-12" \
      "node-18.20.3-0-linux-${OS_ARCH}-debian-12" \
      "cypress-13.10.0-0-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root cypress
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN mkdir /.local && chmod g+rwX /.local

RUN mkdir /app && chmod g+rwX -R /app /opt/bitnami/node/cypress-cache && ln -s /app /e2e && mkdir -p /usr/local/lib /usr/local/bin && ln -s /opt/bitnami/node/node_modules /usr/local/lib/node_modules && ln -s /usr/local/lib/node_modules/cypress/bin/cypress /usr/local/bin/cypress && mkdir -p /.pki /.local /.config /.cache /.fontconfig && chmod g+rwX -R /.pki /.local /.cache /.config /.fontconfig
ENV APP_VERSION="13.10.0" \
    BITNAMI_APP_NAME="cypress" \
    CYPRESS_CACHE_FOLDER="/opt/bitnami/node/cypress-cache" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/node/lib/node_modules/cypress/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "cypress" ]
