# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-17T12:18:50Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/plugin-barman-cloud-sidecar/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/plugin-barman-cloud-sidecar" \
      org.opencontainers.image.title="plugin-barman-cloud-sidecar" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="0.7.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbz2-1.0 libcom-err2 libffi8 libgcc-s1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.5-0 liblzma5 libncursesw6 libnettle8 libp11-kit0 libpq5 libreadline8 libsasl2-2 libsqlite3-0 libssl3 libstdc++6 libtasn1-6 libtinfo6 libunistring2 procps zlib1g
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "plugin-barman-cloud-sidecar-0.7.0-1-linux-${OS_ARCH}-debian-12" \
      "plugin-barman-cloud-0.7.0-2-linux-${OS_ARCH}-debian-12" \
      "python-3.14.0-4-linux-${OS_ARCH}-debian-12" \
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
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN ln -sf /opt/bitnami/plugin-barman-cloud/bin/manager /manager
RUN uninstall_packages curl

ENV APP_VERSION="0.7.0" \
    BITNAMI_APP_NAME="plugin-barman-cloud-sidecar" \
    IMAGE_REVISION="27" \
    PATH="/opt/bitnami/plugin-barman-cloud/bin:/opt/bitnami/python/bin:$PATH"

USER 1001
ENTRYPOINT [ "manager" ]
