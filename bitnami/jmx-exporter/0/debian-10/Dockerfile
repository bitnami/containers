FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libgcc1 procps sudo unzip wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jmx-exporter-0.12.0-0-linux-amd64-debian-10.tar.gz && \
    echo "5eaeb82474209f9b13b9f37b7ca1ce0c137c95c1e19a530a56eb7fcdf640e219  /tmp/bitnami/pkg/cache/jmx-exporter-0.12.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jmx-exporter-0.12.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jmx-exporter-0.12.0-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.242-0-linux-amd64-debian-10.tar.gz && \
    echo "3a70f3d1c3cd9bc6ec581b2a10373a2b323c0b9af40402ce8d19aeb0b3d02400  /tmp/bitnami/pkg/cache/java-1.8.242-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.242-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.242-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="jmx-exporter" \
    BITNAMI_IMAGE_VERSION="0.12.0-debian-10-r11" \
    PATH="/opt/bitnami/java/bin:$PATH"

EXPOSE 5556

WORKDIR /opt/bitnami/jmx-exporter
USER 1001
ENTRYPOINT [ "java", "-jar", "jmx_prometheus_httpserver.jar" ]
CMD [ "5556", "example_configs/httpserver_sample_config.yml" ]
