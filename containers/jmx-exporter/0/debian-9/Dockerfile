FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 libgcc1 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jmx-exporter-0.12.0-0-linux-amd64-debian-9.tar.gz && \
    echo "8002d28f166a1cc5943ab780efe488fc349bd32b892f02b9b2a229f2e2c40228  /tmp/bitnami/pkg/cache/jmx-exporter-0.12.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jmx-exporter-0.12.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jmx-exporter-0.12.0-0-linux-amd64-debian-9.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.222-0-linux-amd64-debian-9.tar.gz && \
    echo "e5a677e160c01cd605bc6aae75cc937d4b2d37514b3e1d0a1dd2d332422e68c7  /tmp/bitnami/pkg/cache/java-1.8.222-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.222-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.222-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="jmx-exporter" \
    BITNAMI_IMAGE_VERSION="0.12.0-debian-9-r38" \
    PATH="/opt/bitnami/java/bin:$PATH"

EXPOSE 5556

WORKDIR /opt/bitnami/jmx-exporter
USER 1001
ENTRYPOINT [ "java", "-jar", "jmx_prometheus_httpserver.jar" ]
CMD [ "5556", "example_configs/httpserver_sample_config.yml" ]
