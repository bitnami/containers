# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL com.vmware.cp.artifact.flavor="sha256:1e1b4657a77f0d47e9220f0c37b9bf7802581b93214fff7d1bd2364c8bf22e8e" \
      org.opencontainers.image.base.name="docker.io/bitnami/minideb:bullseye" \
      org.opencontainers.image.created="2024-01-14T12:04:57Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="2.3.3-debian-11-r3" \
      org.opencontainers.image.title="milvus" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.3.3"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libgcc-s1 libgomp1 libstdc++6 procps
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "yq-4.40.5-1-linux-${OS_ARCH}-debian-11" \
      "wait-for-port-1.0.7-5-linux-${OS_ARCH}-debian-11" \
      "render-template-1.0.6-5-linux-${OS_ARCH}-debian-11" \
      "milvus-2.3.3-1-linux-${OS_ARCH}-debian-11" \
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
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root milvus
RUN mkdir -p /opt/bitnami/milvus/tmp && chmod g+rwX /opt/bitnami/milvus/tmp && ln -s /opt/bitnami/milvus/tmp /run/milvus && mkdir -p /bitnami/milvus/data && chmod g+rwX /bitnami/milvus/data && ln -s /bitnami/milvus/data /var/lib/milvus && ln -s /opt/bitnami/milvus /milvus

ENV APP_VERSION="2.3.3" \
    BITNAMI_APP_NAME="milvus" \
    LD_LIBRARY_PATH="/opt/bitnami/milvus/lib:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/milvus/bin:$PATH"

WORKDIR /opt/bitnami/milvus
USER 1001
ENTRYPOINT [ "/opt/bitnami/milvus/bin/milvus" ]
