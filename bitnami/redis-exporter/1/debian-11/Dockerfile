FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.43.1-debian-11-r4" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/redis-exporter" \
      org.opencontainers.image.title="redis-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.43.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    curl -SsLf https://downloads.bitnami.com/files/stacksmith/redis-exporter-1.43.1-0-linux-amd64-debian-11.tar.gz -o redis-exporter-1.43.1-0-linux-amd64-debian-11.tar.gz && \
    echo "7e35df80db54c39305031e72640811e4dc8536cbe33b84312c4b3bda8400dfd7  redis-exporter-1.43.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf redis-exporter-1.43.1-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf redis-exporter-1.43.1-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.43.1" \
    BITNAMI_APP_NAME="redis-exporter" \
    PATH="/opt/bitnami/redis-exporter/bin:$PATH"

EXPOSE 9121

WORKDIR /opt/bitnami/redis-exporter
USER 1001
ENTRYPOINT [ "redis_exporter" ]
