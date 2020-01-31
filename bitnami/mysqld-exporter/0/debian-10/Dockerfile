FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps sudo unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/mysqld-exporter-0.12.1-0-linux-amd64-debian-10.tar.gz && \
    echo "3855022f069bad1668bc03f3385d57189dfa349c8bb5da5311bfec28f6773d0e  /tmp/bitnami/pkg/cache/mysqld-exporter-0.12.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/mysqld-exporter-0.12.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/mysqld-exporter-0.12.1-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /opt/bitnami/mysqld-exporter/bin/mysqld_exporter /bin/mysqld_exporter

ENV BITNAMI_APP_NAME="mysqld-exporter" \
    BITNAMI_IMAGE_VERSION="0.12.1-debian-10-r6" \
    PATH="/opt/bitnami/mysqld-exporter/bin:$PATH"

EXPOSE 9104

WORKDIR /opt/bitnami/mysqld-exporter
USER 1001
ENTRYPOINT [ "mysqld_exporter" ]
