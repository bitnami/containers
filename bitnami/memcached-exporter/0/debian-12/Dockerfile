# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm AS builder

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "memcached-exporter-0.15.2-1-linux-${OS_ARCH}-debian-12" \
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

######

FROM scratch

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="scratch" \
      org.opencontainers.image.created="2025-04-23T08:44:35Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.ref.name="0.15.2-debian-12-r5" \
      org.opencontainers.image.title="memcached-exporter" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="0.15.2"

COPY rootfs /
COPY --from=builder /opt/bitnami/memcached-exporter/.spdx-memcached-exporter.spdx /opt/bitnami/memcached-exporter/.spdx-memcached-exporter.spdx
COPY --from=builder /opt/bitnami/memcached-exporter/bin/memcached_exporter /opt/bitnami/memcached-exporter/bin/memcached_exporter
COPY --from=builder /opt/bitnami/memcached-exporter/licenses /opt/bitnami/memcached-exporter/licenses

ENV APP_VERSION="0.15.2" \
    BITNAMI_APP_NAME="memcached-exporter" \
    PATH="/opt/bitnami/memcached-exporter/bin:$PATH"

EXPOSE 9150

WORKDIR /opt/bitnami/memcached-exporter

ENTRYPOINT [ "memcached_exporter" ]
