FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 libgcc1 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jmx-exporter-0.12.0-1-linux-amd64-debian-9.tar.gz && \
    echo "4c26bcc1b1e535232dfb5dabd5c8dab8343ce5de01d424c45671a9f847050a09  /tmp/bitnami/pkg/cache/jmx-exporter-0.12.0-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jmx-exporter-0.12.0-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jmx-exporter-0.12.0-1-linux-amd64-debian-9.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.222-1-linux-amd64-debian-9.tar.gz && \
    echo "373c9f3d2943b9ff653fc0e7c69b1d54a75807726691a09190648808500b8253  /tmp/bitnami/pkg/cache/java-1.8.222-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.222-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.222-1-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="jmx-exporter" \
    BITNAMI_IMAGE_VERSION="0.12.0-debian-9-r48" \
    PATH="/opt/bitnami/java/bin:$PATH"

EXPOSE 5556

WORKDIR /opt/bitnami/jmx-exporter
USER 1001
ENTRYPOINT [ "java", "-jar", "jmx_prometheus_httpserver.jar" ]
CMD [ "5556", "example_configs/httpserver_sample_config.yml" ]
