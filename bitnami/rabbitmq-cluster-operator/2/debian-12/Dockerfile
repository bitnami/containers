# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm as builder

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "rabbitmq-cluster-operator-2.12.0-0-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done

######

FROM scratch

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="scratch" \
      org.opencontainers.image.created="2024-12-20T10:41:58Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="2.12.0-debian-12-r0" \
      org.opencontainers.image.title="rabbitmq-cluster-operator" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="2.12.0"

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/rabbitmq-cluster-operator/bin/manager /manager
COPY --from=builder /opt/bitnami/rabbitmq-cluster-operator/.spdx-rabbitmq-cluster-operator.spdx /opt/bitnami/rabbitmq-cluster-operator/.spdx-rabbitmq-cluster-operator.spdx
COPY --from=builder /opt/bitnami/rabbitmq-cluster-operator/licenses /opt/bitnami/rabbitmq-cluster-operator/licenses

ENV APP_VERSION="2.12.0" \
    BITNAMI_APP_NAME="rabbitmq-cluster-operator"

USER 1001

ENTRYPOINT [ "/manager" ]
