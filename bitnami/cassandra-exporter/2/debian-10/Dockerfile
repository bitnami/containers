FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.6-0-linux-amd64-debian-10.tar.gz && \
    echo "f7446f8bec72b6b2606d37ba917accc243e6cd4e722700c39ef83832c46fb0c6  /tmp/bitnami/pkg/cache/java-11.0.6-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.6-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.6-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cassandra-exporter-2.3.0-0-linux-amd64-debian-10.tar.gz && \
    echo "c08f8903b06cfaf20ecccce7caec83b265802af698aa149c6d7fd7b8c20b27f1  /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="cassandra-exporter" \
    BITNAMI_IMAGE_VERSION="2.3.0-debian-10-r10" \
    PATH="/opt/bitnami/java/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/cassandra-exporter
USER 1001
ENTRYPOINT [ "java", "-jar", "./cassandra_exporter.jar", "./config.yml" ]
