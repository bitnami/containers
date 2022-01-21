FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/apache-exporter-0.11.0-2-linux-amd64-debian-10.tar.gz && \
    echo "e0419901e14d347547d4727a177822dbae6aa9e7207ad561e036e3d520d85d2c  /tmp/bitnami/pkg/cache/apache-exporter-0.11.0-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/apache-exporter-0.11.0-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/apache-exporter-0.11.0-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /opt/bitnami/apache-exporter/bin/apache_exporter /bin/apache_exporter
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="apache-exporter" \
    BITNAMI_IMAGE_VERSION="0.11.0-debian-10-r33" \
    PATH="/opt/bitnami/apache-exporter/bin:$PATH"

EXPOSE 9117

WORKDIR /opt/bitnami/apache-exporter
USER 1001
ENTRYPOINT [ "apache_exporter" ]
