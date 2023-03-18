FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bullseye" \
      org.opencontainers.image.created="2023-03-18T22:46:20Z" \
      org.opencontainers.image.description="Application packaged by VMware, Inc" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.9.3-debian-11-r3" \
      org.opencontainers.image.title="multus-cni" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.9.3"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "multus-cni-3.9.3-1-linux-${OS_ARCH}-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root multus-cni
RUN mkdir -p /usr/src && chmod g+x /usr/src && ln -sf /opt/bitnami/multus-cni/ /usr/src/multus-cni && ln -sf /opt/bitnami/multus-cni/bin/entrypoint.sh /entrypoint.sh && mkdir -p /bitnami/multus-cni/host && chmod g+rwX -R /bitnami/multus-cni/host && ln -sf /bitnami/multus-cni/host /host

ENV APP_VERSION="3.9.3" \
    BITNAMI_APP_NAME="multus-cni" \
    PATH="/opt/bitnami/multus-cni/bin:$PATH"

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
