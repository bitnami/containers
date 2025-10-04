# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-04T12:28:02Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/dremio/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/dremio" \
      org.opencontainers.image.title="dremio" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="26.0.5"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libgcc-s1 libstdc++6 procps zlib1g
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "nss-wrapper-1.1.16-0-linux-${OS_ARCH}-debian-12" \
      "jre-21.0.8-12-1-linux-${OS_ARCH}-debian-12" \
      "dremio-26.0.5-2-linux-${OS_ARCH}-debian-12" \
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
RUN mkdir -p /opt/bitnami/dremio/log /opt/bitnami/dremio/tmp /opt/bitnami/dremio/run /bitnami/dremio/data /bitnami/dremio/secrets && chmod g+rwX /bitnami/dremio/secrets /opt/bitnami/dremio/log /opt/bitnami/dremio/tmp /opt/bitnami/dremio/run /bitnami/dremio/data && ln -s /opt/bitnami/dremio/log /var/log/dremio && ln -s /bitnami/dremio/data /var/lib/dremio && ln -s /bitnami/dremio/data /opt/bitnami/dremio/data && ln -s /opt/bitnami/dremio /opt/dremio && ln -s /opt/bitnami/dremio/tmp /var/run/dremio
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN uninstall_packages curl

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="26.0.5" \
    BITNAMI_APP_NAME="dremio" \
    IMAGE_REVISION="2" \
    JAVA_HOME="/opt/bitnami/java" \
    LD_LIBRARY_PATH="/opt/bitnami/java/lib/server:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/dremio/bin:$PATH"

EXPOSE 9047 31010 45678

WORKDIR /opt/bitnami/dremio
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/dremio/entrypoint.sh", "dremio" ]
CMD [ "start-fg" ]
