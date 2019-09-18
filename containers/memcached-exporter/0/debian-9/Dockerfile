FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/memcached-exporter-0.6.0-0-linux-amd64-debian-9.tar.gz && \
    echo "93b4bd71ae0e5ec2fbad823ba177c33ce4bffb70baaf5218e93fdf901020aaa3  /tmp/bitnami/pkg/cache/memcached-exporter-0.6.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/memcached-exporter-0.6.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/memcached-exporter-0.6.0-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="memcached-exporter" \
    BITNAMI_IMAGE_VERSION="0.6.0-debian-9-r23" \
    PATH="/opt/bitnami/memcached-exporter/bin:$PATH"

EXPOSE 9150

WORKDIR /opt/bitnami/memcached-exporter
USER 1001
ENTRYPOINT [ "memcached_exporter" ]
