FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/logstash-exporter-7.3.0-3-linux-amd64-debian-10.tar.gz && \
    echo "96bf31170f7bd3d9900daef6899330c4abb918c833f362ae7250454cf237f5e6  /tmp/bitnami/pkg/cache/logstash-exporter-7.3.0-3-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/logstash-exporter-7.3.0-3-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/logstash-exporter-7.3.0-3-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="logstash-exporter" \
    BITNAMI_IMAGE_VERSION="7.3.0-debian-10-r412" \
    PATH="/opt/bitnami/logstash-exporter/bin:$PATH"

EXPOSE 9198

WORKDIR /opt/bitnami/logstash-exporter
USER 1001
ENTRYPOINT [ "logstash_exporter" ]
