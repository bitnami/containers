FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-exporter-0.18.1-0-linux-amd64-debian-9.tar.gz && \
    echo "e4fb4c22d78a6345ae061b7f8fdbccc87026dc0624bedd9104f9ffece0679ea5  /tmp/bitnami/pkg/cache/node-exporter-0.18.1-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-exporter-0.18.1-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-exporter-0.18.1-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="node-exporter" \
    BITNAMI_IMAGE_VERSION="0.18.1-debian-9-r22" \
    PATH="/opt/bitnami/node-exporter/bin:$PATH"

EXPOSE 9100

WORKDIR /opt/bitnami/node-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/node-exporter/bin/node_exporter" ]
