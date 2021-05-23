FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.11-0-linux-amd64-debian-10.tar.gz && \
    echo "8cf28afc1090b0fec1ad841012ead25b59d2d5f4212742c3d62e6007ef57850b  /tmp/bitnami/pkg/cache/java-11.0.11-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.11-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.11-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cassandra-exporter-2.3.4-3-linux-amd64-debian-10.tar.gz && \
    echo "d7b1f6052a1d117092464718a7125db742c009619161dd00e57dd941e7baa3e0  /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.4-3-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.4-3-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.4-3-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="cassandra-exporter" \
    BITNAMI_IMAGE_VERSION="2.3.4-debian-10-r412" \
    PATH="/opt/bitnami/java/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/cassandra-exporter
USER 1001
ENTRYPOINT [ "java", "-jar", "./cassandra_exporter.jar", "./config.yml" ]
