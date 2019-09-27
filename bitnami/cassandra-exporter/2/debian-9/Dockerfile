FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.4-1-linux-amd64-debian-9.tar.gz && \
    echo "561cd1095eaca816109f92dcb5f68a53b788cfa6734782763350b980a4e5538a  /tmp/bitnami/pkg/cache/java-11.0.4-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.4-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.4-1-linux-amd64-debian-9.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cassandra-exporter-2.3.0-1-linux-amd64-debian-9.tar.gz && \
    echo "636c66488fb5e299aee827f3b873001b3cafa81449ca6e6887600dc181d20575  /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.0-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.0-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cassandra-exporter-2.3.0-1-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="cassandra-exporter" \
    BITNAMI_IMAGE_VERSION="2.3.0-debian-9-r50" \
    PATH="/opt/bitnami/java/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/cassandra-exporter
USER 1001
ENTRYPOINT [ "java", "-jar", "./cassandra_exporter.jar", "./config.yml" ]
