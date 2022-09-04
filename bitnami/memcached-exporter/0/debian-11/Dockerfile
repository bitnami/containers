FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.10.0-debian-11-r29" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/memcached-exporter" \
      org.opencontainers.image.title="memcached-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.10.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f memcached-exporter-0.10.0-4-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/memcached-exporter-0.10.0-4-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "31fabf6b88a882c19a84d9cdac4c21dc170fd73cd636a524dcc4003f6fd19cfc  memcached-exporter-0.10.0-4-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf memcached-exporter-0.10.0-4-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf memcached-exporter-0.10.0-4-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.10.0" \
    BITNAMI_APP_NAME="memcached-exporter" \
    PATH="/opt/bitnami/memcached-exporter/bin:$PATH"

EXPOSE 9150

WORKDIR /opt/bitnami/memcached-exporter
USER 1001
ENTRYPOINT [ "memcached_exporter" ]
