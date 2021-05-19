FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/logstash-exporter-7.3.0-1-linux-amd64-debian-10.tar.gz && \
    echo "8c1dc08ea0c5611335ccc73466b476574090f2c8e5f3e0c593b8667f7844831e  /tmp/bitnami/pkg/cache/logstash-exporter-7.3.0-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/logstash-exporter-7.3.0-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/logstash-exporter-7.3.0-1-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="logstash-exporter" \
    BITNAMI_IMAGE_VERSION="7.3.0-debian-10-r189" \
    PATH="/opt/bitnami/logstash-exporter/bin:$PATH"

EXPOSE 9198

WORKDIR /opt/bitnami/logstash-exporter
USER 1001
ENTRYPOINT [ "logstash_exporter" ]
