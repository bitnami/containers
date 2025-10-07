# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-07T00:44:50Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/arangodb/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/arangodb" \
      org.opencontainers.image.title="arangodb" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="3.11.14"

ENV OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libatomic1 libgcc-s1 libssl3 libstdc++6 procps
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "arangodb-3.11.14-0-linux-${OS_ARCH}-debian-12" \
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
RUN useradd -r -u 1000 -g root arangodb
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN ln -s /opt/bitnami/arangodb/sbin/arangod /usr/sbin && \
    chmod g+w -R /opt/bitnami/arangodb/var && \
    ln -s /opt/bitnami/arangodb/etc/arangodb3 /etc/ && \
    mkdir -p /var/log && \
    mkdir -p /var/lib && \
    ln -s /opt/bitnami/arangodb/var/lib/arangodb3 /var/lib/ && \
    ln -s /opt/bitnami/arangodb/var/lib/arangodb3-apps /var/lib && \
    ln -s /opt/bitnami/arangodb/var/log/arangodb3 /var/log/ && \
    ln -s /opt/bitnami/arangodb/share/arangodb3 /usr/share/ && \
    mkdir -p /etc/opt/bitnami && \
    ln -s /opt/bitnami/arangodb/etc /etc/opt/bitnami/arangodb && \
    mkdir -p /var/opt/bitnami && \
    ln -s /opt/bitnami/arangodb/var /var/opt/bitnami/arangodb
RUN uninstall_packages curl

ENV APP_VERSION="3.11.14" \
    BITNAMI_APP_NAME="arangodb" \
    IMAGE_REVISION="6" \
    PATH="/opt/bitnami/arangodb/sbin:/opt/bitnami/arangodb/bin:$PATH"

EXPOSE 8529

ENTRYPOINT [ "/opt/bitnami/arangodb/sbin/arangod" ]
