FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/memcached-exporter-0.9.0-0-linux-amd64-debian-11.tar.gz && \
    echo "23e2e1027a316b9453adff87e118ee9c32d601be0a75734d6a1d90992f141f14  /tmp/bitnami/pkg/cache/memcached-exporter-0.9.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/memcached-exporter-0.9.0-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/memcached-exporter-0.9.0-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.9.0" \
    BITNAMI_APP_NAME="memcached-exporter" \
    PATH="/opt/bitnami/memcached-exporter/bin:$PATH"

EXPOSE 9150

WORKDIR /opt/bitnami/memcached-exporter
USER 1001
ENTRYPOINT [ "memcached_exporter" ]
