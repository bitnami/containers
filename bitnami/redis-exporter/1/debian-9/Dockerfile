FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/redis-exporter-1.3.3-0-linux-amd64-debian-9.tar.gz && \
    echo "dae769ca601bdee21303a4c984639769cb2a5197d41c13b4950f70cb0e03c9dc  /tmp/bitnami/pkg/cache/redis-exporter-1.3.3-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/redis-exporter-1.3.3-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/redis-exporter-1.3.3-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="redis-exporter" \
    BITNAMI_IMAGE_VERSION="1.3.3-debian-9-r0" \
    PATH="/opt/bitnami/redis-exporter/bin:$PATH"

EXPOSE 9121

WORKDIR /opt/bitnami/redis-exporter
USER 1001
ENTRYPOINT [ "redis_exporter" ]
