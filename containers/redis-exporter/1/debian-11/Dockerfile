FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/redis-exporter-1.39.0-0-linux-amd64-debian-11.tar.gz && \
    echo "09cd50b422a50329923afc46e74425ddf780b566b9fde31dcb31ca00d17b97c6  /tmp/bitnami/pkg/cache/redis-exporter-1.39.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/redis-exporter-1.39.0-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/redis-exporter-1.39.0-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.39.0" \
    BITNAMI_APP_NAME="redis-exporter" \
    PATH="/opt/bitnami/redis-exporter/bin:$PATH"

EXPOSE 9121

WORKDIR /opt/bitnami/redis-exporter
USER 1001
ENTRYPOINT [ "redis_exporter" ]
