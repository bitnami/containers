FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/redis-exporter-1.1.1-0-linux-amd64-debian-9.tar.gz && \
    echo "f90bc119e165c772c86cfad7808838e498673bc77355bdc173a5a8c4e3e159aa  /tmp/bitnami/pkg/cache/redis-exporter-1.1.1-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/redis-exporter-1.1.1-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/redis-exporter-1.1.1-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="redis-exporter" \
    BITNAMI_IMAGE_VERSION="1.1.1-debian-9-r9" \
    PATH="/opt/bitnami/redis-exporter/bin:$PATH"

EXPOSE 9121

WORKDIR /opt/bitnami/redis-exporter
USER 1001
ENTRYPOINT [ "redis_exporter" ]
