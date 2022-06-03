FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.333-0-linux-amd64-debian-10.tar.gz && \
    echo "4b5fa59710327cb409d6f469335a71ba1ce1ad2068e30b2aa35b9cbc101bcd6f  /tmp/bitnami/pkg/cache/java-1.8.333-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.333-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.333-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jmx-exporter-0.17.0-0-linux-amd64-debian-10.tar.gz && \
    echo "11194c144de7f0dd4a7b90120c28bbe2c72144b84faf5b5a2e3f8f43b819a24e  /tmp/bitnami/pkg/cache/jmx-exporter-0.17.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jmx-exporter-0.17.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jmx-exporter-0.17.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN chown -R 1001:1001 /opt/bitnami/jmx-exporter

ENV APP_VERSION="0.17.0" \
    BITNAMI_APP_NAME="jmx-exporter" \
    PATH="/opt/bitnami/java/bin:$PATH"

EXPOSE 5556

WORKDIR /opt/bitnami/jmx-exporter
USER 1001
ENTRYPOINT [ "java", "-jar", "jmx_prometheus_httpserver.jar" ]
CMD [ "5556", "example_configs/httpserver_sample_config.yml" ]
