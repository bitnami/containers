FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kafka-exporter-1.4.2-0-linux-amd64-debian-10.tar.gz && \
    echo "fd8d77b38227f0b5996ccf22e19eac068fd0edcdf2a200edbeea7961ea1b62be  /tmp/bitnami/pkg/cache/kafka-exporter-1.4.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kafka-exporter-1.4.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kafka-exporter-1.4.2-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="kafka-exporter" \
    BITNAMI_IMAGE_VERSION="1.4.2-debian-10-r6" \
    PATH="/opt/bitnami/kafka-exporter/bin:$PATH"

EXPOSE 9308

WORKDIR /opt/bitnami/kafka-exporter
USER 1001
ENTRYPOINT [ "kafka_exporter" ]
