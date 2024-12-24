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
      "kubeapps-asset-syncer-2.12.1-0-linux-${OS_ARCH}-debian-12" \
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
      org.opencontainers.image.created="2024-12-24T09:10:52Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="2.12.1-debian-12-r0" \
      org.opencontainers.image.title="kubeapps-asset-syncer" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="2.12.1"

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/kubeapps-asset-syncer/bin/asset-syncer /asset-syncer
COPY --from=builder /opt/bitnami/kubeapps-asset-syncer/.spdx-kubeapps-asset-syncer.spdx /opt/bitnami/kubeapps-asset-syncer/.spdx-kubeapps-asset-syncer.spdx
COPY --from=builder /opt/bitnami/kubeapps-asset-syncer/licenses /opt/bitnami/kubeapps-asset-syncer/licenses

ENV APP_VERSION="2.12.1" \
    BITNAMI_APP_NAME="kubeapps-asset-syncer"

USER 1001

CMD [ "/asset-syncer" ]
