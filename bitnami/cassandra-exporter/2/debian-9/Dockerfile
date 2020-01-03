FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.5-0-linux-amd64-debian-9.tar.gz && \
    echo "9fc7502ca3c073e6ae7dd6cfa0c2da6b6c26caccbe41b6d7b5a9d26050ee54ff  /tmp/bitnami/pkg/cache/java-11.0.5-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.5-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.5-0-linux-amd64-debian-9.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cassandra-exporter-2.3.0-1-linux-amd64-debian-9.tar.gz && \
    echo "636c66488fb5e299aee827f3b873001b3cafa81449ca6e6887600dc181d20575  /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.0-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.0-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.0-1-linux-amd64-debian-9.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="cassandra-exporter" \
    BITNAMI_IMAGE_VERSION="2.3.0-debian-9-r130" \
    PATH="/opt/bitnami/java/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/cassandra-exporter
USER 1001
ENTRYPOINT [ "java", "-jar", "./cassandra_exporter.jar", "./config.yml" ]
