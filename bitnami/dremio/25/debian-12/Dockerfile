# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:c50c90cfd9d12b445b011e6ad529f1ad3daea45c26d20b00732fae3cd71f6a83" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-01-08T21:45:26Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/dremio/README.md" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="25.2.0-debian-12-r3" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/dremio" \
      org.opencontainers.image.title="dremio" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="25.2.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libgcc-s1 libstdc++6 procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "java-21.0.5-11-1-linux-${OS_ARCH}-debian-12" \
      "dremio-25.2.0-0-linux-${OS_ARCH}-debian-12" \
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
RUN mkdir -p /opt/bitnami/dremio/log /opt/bitnami/dremio/tmp /opt/bitnami/dremio/run /bitnami/dremio/data /bitnami/dremio/secrets && chmod g+rwX /bitnami/dremio/secrets /opt/bitnami/dremio/log /opt/bitnami/dremio/tmp /opt/bitnami/dremio/run /bitnami/dremio/data && ln -s /opt/bitnami/dremio/log /var/log/dremio && ln -s /bitnami/dremio/data /var/lib/dremio && ln -s /bitnami/dremio/data /opt/bitnami/dremio/data && ln -s /opt/bitnami/dremio /opt/dremio && ln -s /opt/bitnami/dremio/tmp /var/run/dremio
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="25.2.0" \
    BITNAMI_APP_NAME="dremio" \
    JAVA_HOME="/opt/bitnami/java" \
    LD_LIBRARY_PATH="/opt/bitnami/java/lib/server:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/dremio/bin:$PATH"

EXPOSE 9047 31010 45678

WORKDIR /opt/bitnami/dremio
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/dremio/entrypoint.sh", "dremio" ]
CMD [ "start-fg" ]
