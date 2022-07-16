FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/mysqld-exporter-0.14.0-152-linux-amd64-debian-11.tar.gz && \
    echo "c6779690b7024c995c3610f81e20766917d06f90c274ce79266d798e16f80ae6  /tmp/bitnami/pkg/cache/mysqld-exporter-0.14.0-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/mysqld-exporter-0.14.0-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/mysqld-exporter-0.14.0-152-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/mysqld-exporter/bin/mysqld_exporter /bin/mysqld_exporter

ENV APP_VERSION="0.14.0" \
    BITNAMI_APP_NAME="mysqld-exporter" \
    PATH="/opt/bitnami/mysqld-exporter/bin:$PATH"

EXPOSE 9104

WORKDIR /opt/bitnami/mysqld-exporter
USER 1001
ENTRYPOINT [ "mysqld_exporter" ]
