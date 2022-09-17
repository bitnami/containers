FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.21.5-debian-11-r18" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/envoy" \
      org.opencontainers.image.title="envoy" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.21.5"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f envoy-1.21.5-2-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/envoy-1.21.5-2-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/envoy-1.21.5-2-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c envoy-1.21.5-2-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf envoy-1.21.5-2-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf envoy-1.21.5-2-linux-${OS_ARCH}-debian-11.tar.gz envoy-1.21.5-2-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.21.5" \
    BITNAMI_APP_NAME="envoy" \
    PATH="/opt/bitnami/envoy/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/envoy/bin/envoy" ]
CMD [ "-c", "/opt/bitnami/envoy/conf/envoy.yaml" ]
