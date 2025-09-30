# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-09-30T12:47:34Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/milvus/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/milvus" \
      org.opencontainers.image.title="milvus" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="2.6.3"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libaio1 libatomic1 libgcc-s1 libgfortran5 libgomp1 libopenblas0-pthread libquadmath0 libstdc++6 procps
RUN --mount=type=secret,id=downloads_url,env=SECRET_DOWNLOADS_URL \
    DOWNLOADS_URL=${SECRET_DOWNLOADS_URL:-${DOWNLOADS_URL}} ; \
    mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "milvus-2.6.3-0-linux-${OS_ARCH}-debian-12" \
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
RUN useradd -r -u 1001 -g root milvus
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN mkdir -p /opt/bitnami/milvus/tmp && chmod g+rwX /opt/bitnami/milvus/tmp && ln -s /opt/bitnami/milvus/tmp /run/milvus && mkdir -p /bitnami/milvus/data && chmod g+rwX /bitnami/milvus/data && ln -s /bitnami/milvus/data /var/lib/milvus && ln -s /opt/bitnami/milvus /milvus
RUN uninstall_packages curl

ENV APP_VERSION="2.6.3" \
    BITNAMI_APP_NAME="milvus" \
    IMAGE_REVISION="0" \
    LD_LIBRARY_PATH="/opt/bitnami/milvus/lib:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/milvus/bin:$PATH"

WORKDIR /opt/bitnami/milvus
USER 1001
ENTRYPOINT [ "/opt/bitnami/milvus/bin/milvus" ]
