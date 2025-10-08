# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-08T00:12:44Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/hyperledger-fabric-ca/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/hyperledger-fabric-ca" \
      org.opencontainers.image.title="hyperledger-fabric-ca" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="1.5.15"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "golang-1.25.2-0-linux-${OS_ARCH}-debian-12" \
      "hyperledger-fabric-ca-1.5.15-11-linux-${OS_ARCH}-debian-12" \
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
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /opt/bitnami/hyperledger-fabric-ca/etc && chmod g+rw /opt/bitnami/hyperledger-fabric-ca/etc && mkdir /etc/hyperledger && ln -s /opt/bitnami/hyperledger-fabric-ca/etc /etc/hyperledger/fabric-ca-server
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN uninstall_packages curl

ENV APP_VERSION="1.5.15" \
    BITNAMI_APP_NAME="hyperledger-fabric-ca" \
    FABRIC_CA_HOME="/opt/bitnami/hyperledger-fabric-ca/etc" \
    IMAGE_REVISION="25" \
    PATH="/go/bin:/opt/bitnami/go/bin:/opt/bitnami/hyperledger-fabric-ca/bin:$PATH"

USER 1001
CMD [ "fabric-ca-server", "start", "-b", "admin:adminpw" ]
