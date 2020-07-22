FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/redis-exporter-1.9.0-0-linux-amd64-debian-10.tar.gz && \
    echo "c03cd8fbc667673db399960235d7b059239879e31f70ec7fe717b07efeb7a59d  /tmp/bitnami/pkg/cache/redis-exporter-1.9.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/redis-exporter-1.9.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/redis-exporter-1.9.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="redis-exporter" \
    BITNAMI_IMAGE_VERSION="1.9.0-debian-10-r12" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/redis-exporter/bin:$PATH"

EXPOSE 9121

WORKDIR /opt/bitnami/redis-exporter
USER 1001
ENTRYPOINT [ "redis_exporter" ]
