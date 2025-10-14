# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/bitnami/minideb:bookworm

ARG DOWNLOADS_URL="downloads.bitnami.com/files/stacksmith"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-14T04:57:19Z" \
      org.opencontainers.image.description="Application packaged by Broadcom, Inc." \
      org.opencontainers.image.documentation="https://github.com/bitnami/containers/tree/main/bitnami/multus-cni/README.md" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/multus-cni" \
      org.opencontainers.image.title="multus-cni" \
      org.opencontainers.image.vendor="Broadcom, Inc." \
      org.opencontainers.image.version="4.2.2"

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
      "multus-cni-4.2.2-5-linux-${OS_ARCH}-debian-12" \
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
RUN useradd -r -u 1001 -g root multus-cni
RUN mkdir -p /usr/src && chmod g+x /usr/src && ln -sf /opt/bitnami/multus-cni/ /usr/src/multus-cni && ln -sf /opt/bitnami/multus-cni/bin/thin_entrypoint /thin_entrypoint && ln -sf /opt/bitnami/multus-cni/bin/install_multus /install_multus && mkdir -p /bitnami/multus-cni/host && chmod g+rwX -R /bitnami/multus-cni/host && ln -sf /bitnami/multus-cni/host /host
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN uninstall_packages curl

ENV APP_VERSION="4.2.2" \
    BITNAMI_APP_NAME="multus-cni" \
    IMAGE_REVISION="7" \
    PATH="/opt/bitnami/multus-cni/bin:$PATH"

USER 1001
ENTRYPOINT [ "/thin_entrypoint" ]
