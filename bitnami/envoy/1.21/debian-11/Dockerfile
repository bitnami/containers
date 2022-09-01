FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.21.5-debian-11-r12" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/envoy" \
      org.opencontainers.image.title="envoy" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.21.5"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f envoy-1.21.5-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/envoy-1.21.5-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "0ddb4d1f6b29b38e3711224c730064456f700e2e33c8dc376b58cce215e60317  envoy-1.21.5-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf envoy-1.21.5-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf envoy-1.21.5-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.21.5" \
    BITNAMI_APP_NAME="envoy" \
    PATH="/opt/bitnami/envoy/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/envoy/bin/envoy" ]
CMD [ "-c", "/opt/bitnami/envoy/conf/envoy.yaml" ]
