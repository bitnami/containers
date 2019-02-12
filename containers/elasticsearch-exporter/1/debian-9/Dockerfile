FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/elasticsearch-exporter-1.0.2-20-linux-amd64-debian-9.tar.gz && \
    echo "f2dd0fa14264719606de2ae032b410167b0f1a916c2897f24ac69fbef636fb6d  /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.0.2-20-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.0.2-20-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.0.2-20-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="elasticsearch-exporter" \
    BITNAMI_IMAGE_VERSION="1.0.2-debian-9-r206" \
    PATH="/opt/bitnami/elasticsearch-exporter/bin:$PATH"

EXPOSE 9108

WORKDIR /opt/bitnami/elasticsearch-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/elasticsearch-exporter/bin/elasticsearch_exporter" ]
