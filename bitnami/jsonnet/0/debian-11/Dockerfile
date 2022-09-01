FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.18.0-debian-11-r32" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/jsonnet" \
      org.opencontainers.image.title="jsonnet" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.18.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc-s1 libstdc++6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f jsonnet-0.18.0-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/jsonnet-0.18.0-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e2cdb6d73e8f4d9f7632dde4e0ddc2d2f188b25aabcd4fa0f93b6f8a7d0542f0  jsonnet-0.18.0-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf jsonnet-0.18.0-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf jsonnet-0.18.0-153-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

RUN chmod +x /opt/bitnami/jsonnet/bin/jsonnet
ENV APP_VERSION="0.18.0" \
    BITNAMI_APP_NAME="jsonnet" \
    PATH="/opt/bitnami/jsonnet/bin:$PATH"

USER 1001
ENTRYPOINT [ "jsonnet" ]
CMD [ "--help" ]
