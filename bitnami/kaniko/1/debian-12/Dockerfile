# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm AS builder

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV HOME="/root" \
    OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "kaniko-1.25.1-1-linux-${OS_ARCH}-debian-12" \
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

RUN mkdir -p /out/kaniko/.docker /out/etc && cp /opt/bitnami/kaniko/bin/* /out/kaniko && cp /opt/bitnami/kaniko/nsswitch/nsswitch.conf /out/etc && chmod 775 /out/kaniko

######

FROM scratch

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV HOME="/root" \
    OS_ARCH="${TARGETARCH:-amd64}"

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="scratch" \
      org.opencontainers.image.created="2025-08-07T01:54:20Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.title="kaniko" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="1.25.1"

COPY rootfs /
COPY --from=builder /opt/bitnami/kaniko/.spdx-kaniko.spdx /opt/bitnami/kaniko/.spdx-kaniko.spdx
COPY --from=builder /opt/bitnami/kaniko/licenses /opt/bitnami/kaniko/licenses
COPY --from=builder /out /

ENV APP_VERSION="1.25.1" \
    BITNAMI_APP_NAME="kaniko" \
    DOCKER_CONFIG="/kaniko/.docker" \
    DOCKER_CREDENTIAL_GCR_CONFIG="/kaniko/.config/gcloud/docker_credential_gcr_config.json" \
    PATH="/kaniko" \
    SSL_CERT_DIR="/etc/ssl/certs/" \
    USER="root"

WORKDIR /workspace

ENTRYPOINT [ "/kaniko/executor" ]
