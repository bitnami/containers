# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm as builder

ARG TARGETARCH

ENV HOME="/root" \
    OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "kaniko-1.23.1-0-linux-${OS_ARCH}-debian-12" \
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

RUN mkdir -p /out/kaniko/.docker /out/etc && cp /opt/bitnami/kaniko/bin/* /out/kaniko && cp /opt/bitnami/kaniko/nsswitch/nsswitch.conf /out/etc && chmod 775 /out/kaniko

######

FROM scratch

ARG TARGETARCH

ENV HOME="/root" \
    OS_ARCH="${TARGETARCH:-amd64}"

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="scratch" \
      org.opencontainers.image.created="2024-06-08T02:11:55Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="1.23.1-debian-12-r0" \
      org.opencontainers.image.title="kaniko" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="1.23.1"

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /out /
COPY --from=builder /opt/bitnami/kaniko/.spdx-kaniko.spdx /opt/bitnami/kaniko/.spdx-kaniko.spdx
COPY --from=builder /opt/bitnami/kaniko/licenses /opt/bitnami/kaniko/licenses

ENV APP_VERSION="1.23.1" \
    BITNAMI_APP_NAME="kaniko" \
    DOCKER_CONFIG="/kaniko/.docker" \
    DOCKER_CREDENTIAL_GCR_CONFIG="/kaniko/.config/gcloud/docker_credential_gcr_config.json" \
    PATH="/kaniko" \
    SSL_CERT_DIR="/etc/ssl/certs/" \
    USER="root"

WORKDIR /workspace

ENTRYPOINT [ "/kaniko/executor" ]
