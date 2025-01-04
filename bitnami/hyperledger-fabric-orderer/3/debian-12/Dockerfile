# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-01-02T23:53:24Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/hyperledger-fabric-orderer/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.0.0-debian-12-r6" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/hyperledger-fabric-orderer" \
      org.opencontainers.image.title="hyperledger-fabric-orderer" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="3.0.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "hyperledger-fabric-orderer-3.0.0-4-linux-${OS_ARCH}-debian-12" \
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
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /opt/bitnami/hyperledger-fabric-orderer/var && chmod g+rwX /opt/bitnami/hyperledger-fabric-orderer/var && ln -s /opt/bitnami/hyperledger-fabric-orderer/var /var/hyperledger && mkdir -p /etc/hyperledger && ln -s /opt/bitnami/hyperledger-fabric-orderer/etc /etc/hyperledger/fabric && echo "hosts: files dns" > /etc/nsswitch.conf
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

ENV APP_VERSION="3.0.0" \
    BITNAMI_APP_NAME="hyperledger-fabric-orderer" \
    FABRIC_CFG_PATH="/opt/bitnami/hyperledger-fabric-orderer/etc" \
    PATH="/opt/bitnami/hyperledger-fabric-orderer/bin:$PATH"

EXPOSE 7050

USER 1001
CMD [ "orderer", "start" ]
