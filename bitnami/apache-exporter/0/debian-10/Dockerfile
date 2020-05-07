FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/apache-exporter-0.8.0-0-linux-amd64-debian-10.tar.gz && \
    echo "e87f588e2a581f63c6e348fe15136a25427a8e2aa5a969c81ab9614c7316479a  /tmp/bitnami/pkg/cache/apache-exporter-0.8.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/apache-exporter-0.8.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/apache-exporter-0.8.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /opt/bitnami/apache-exporter/bin/apache_exporter /bin/apache_exporter

ENV BITNAMI_APP_NAME="apache-exporter" \
    BITNAMI_IMAGE_VERSION="0.8.0-debian-10-r37" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/apache-exporter/bin:$PATH"

EXPOSE 9117

WORKDIR /opt/bitnami/apache-exporter
USER 1001
ENTRYPOINT [ "apache_exporter" ]
