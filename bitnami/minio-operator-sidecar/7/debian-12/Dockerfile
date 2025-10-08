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
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "minio-operator-sidecar-7.1.1-8-linux-${OS_ARCH}-debian-12" \
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
RUN uninstall_packages curl

######

FROM scratch

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL org.opencontainers.image.base.name="scratch" \
      org.opencontainers.image.created="2025-10-08T01:56:10Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.title="minio-operator-sidecar" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="7.1.1"

COPY rootfs /
COPY --from=builder /opt/bitnami/minio-operator-sidecar/bin /
COPY --from=builder /opt/bitnami/minio-operator-sidecar/.spdx-minio-operator-sidecar.spdx /opt/bitnami/minio-operator-sidecar/.spdx-minio-operator-sidecar.spdx
COPY --from=builder /opt/bitnami/minio-operator-sidecar/licenses /opt/bitnami/minio-operator-sidecar/licenses

ENV APP_VERSION="7.1.1" \
    BITNAMI_APP_NAME="minio-operator-sidecar" \
    IMAGE_REVISION="10" \
    PATH="/"

USER 1001

ENTRYPOINT [ "/minio-operator-sidecar" ]
