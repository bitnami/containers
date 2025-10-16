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
      "rmq-default-credential-updater-1.0.9-0-linux-${OS_ARCH}-debian-12" \
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
      org.opencontainers.image.created="2025-10-15T09:16:56Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.title="rmq-default-credential-updater" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="1.0.9"

COPY rootfs /
COPY --from=builder /opt/bitnami/rmq-default-credential-updater/.spdx-rmq-default-credential-updater.spdx /opt/bitnami/rmq-default-credential-updater/.spdx-rmq-default-credential-updater.spdx
COPY --from=builder /opt/bitnami/rmq-default-credential-updater/bin/default-user-credential-updater /opt/bitnami/rmq-default-credential-updater/bin/default-user-credential-updater
COPY --from=builder /opt/bitnami/rmq-default-credential-updater/licenses /opt/bitnami/rmq-default-credential-updater/licenses

ENV APP_VERSION="1.0.9" \
    BITNAMI_APP_NAME="rmq-default-credential-updater" \
    IMAGE_REVISION="0" \
    PATH="/opt/bitnami/rmq-default-credential-updater/bin:$PATH"

USER 1001

ENTRYPOINT [ "default-user-credential-updater" ]
