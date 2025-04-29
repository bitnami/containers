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
      "oras-1.2.3-0-linux-${OS_ARCH}-debian-12" \
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
      org.opencontainers.image.created="2025-04-29T08:35:02Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.ref.name="1.2.3-debian-12-r0" \
      org.opencontainers.image.title="oras" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="1.2.3"

COPY rootfs /
COPY --from=builder /opt/bitnami/oras/.spdx-oras.spdx /opt/bitnami/oras/.spdx-oras.spdx
COPY --from=builder /opt/bitnami/oras/bin/oras /opt/bitnami/oras/bin/oras
COPY --from=builder /opt/bitnami/oras/licenses /opt/bitnami/oras/licenses

ENV APP_VERSION="1.2.3" \
    BITNAMI_APP_NAME="oras" \
    PATH="/opt/bitnami/oras/bin:$PATH"

USER 1001

ENTRYPOINT [ "oras" ]
