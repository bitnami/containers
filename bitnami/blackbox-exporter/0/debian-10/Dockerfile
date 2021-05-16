FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/blackbox-exporter-0.19.0-0-linux-amd64-debian-10.tar.gz && \
    echo "39b859d2d6823acb8c0858dcb1c0ee9a0c8dc1d95c78e480cd9b5404696f046e  /tmp/bitnami/pkg/cache/blackbox-exporter-0.19.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/blackbox-exporter-0.19.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/blackbox-exporter-0.19.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="blackbox-exporter" \
    BITNAMI_IMAGE_VERSION="0.19.0-debian-10-r5" \
    PATH="/opt/bitnami/blackbox-exporter/bin:$PATH"

EXPOSE 9115

WORKDIR /opt/bitnami/blackbox-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/blackbox-exporter/bin/blackbox_exporter" ]
