FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-exporter-0.17.0-20-linux-amd64-debian-9.tar.gz && \
    echo "a76daf587be91ab5d88179e17e68be1b3818a23a1a1ee3694eb52f8c5b924404  /tmp/bitnami/pkg/cache/node-exporter-0.17.0-20-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-exporter-0.17.0-20-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-exporter-0.17.0-20-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="node-exporter" \
    BITNAMI_IMAGE_VERSION="0.17.0-debian-9-r74" \
    PATH="/opt/bitnami/node-exporter/bin:$PATH"

EXPOSE 9100

WORKDIR /opt/bitnami/node-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/node-exporter/bin/node_exporter" ]
