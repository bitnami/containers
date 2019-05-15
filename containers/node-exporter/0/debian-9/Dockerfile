FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-exporter-0.18.0-0-linux-amd64-debian-9.tar.gz && \
    echo "aaa5261046d32bb17c47ef1b6a7ed18b2321cc78fdb015e79090028459c8463e  /tmp/bitnami/pkg/cache/node-exporter-0.18.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-exporter-0.18.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-exporter-0.18.0-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="node-exporter" \
    BITNAMI_IMAGE_VERSION="0.18.0-debian-9-r3" \
    PATH="/opt/bitnami/node-exporter/bin:$PATH"

EXPOSE 9100

WORKDIR /opt/bitnami/node-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/node-exporter/bin/node_exporter" ]
