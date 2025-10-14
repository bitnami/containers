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
      "charts-syncer-2.1.5-2-linux-${OS_ARCH}-debian-12" \
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
RUN mkdir -p /rootfs/tmp && mkdir /rootfs/.charts-syncer && chmod g+rwX /rootfs/tmp /rootfs/.charts-syncer
RUN uninstall_packages curl

######

FROM scratch

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL org.opencontainers.image.base.name="scratch" \
      org.opencontainers.image.created="2025-10-13T23:50:45Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.title="charts-syncer" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="2.1.5"

COPY rootfs /
COPY --from=builder /opt/bitnami/charts-syncer/.spdx-charts-syncer.spdx /opt/bitnami/charts-syncer/.spdx-charts-syncer.spdx
COPY --from=builder /opt/bitnami/charts-syncer/bin/charts-syncer /opt/bitnami/charts-syncer/bin/charts-syncer
COPY --from=builder /opt/bitnami/charts-syncer/licenses /opt/bitnami/charts-syncer/licenses
COPY --from=builder /rootfs /

ENV APP_VERSION="2.1.5" \
    BITNAMI_APP_NAME="charts-syncer" \
    IMAGE_REVISION="2" \
    PATH="/opt/bitnami/charts-syncer/bin:$PATH"

USER 1001

ENTRYPOINT [ "charts-syncer" ]
