FROM bitnami/centos-extras-base:7-r143
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/mysqld-exporter-0.12.1-0-linux-x86_64-centos-7.tar.gz && \
    echo "11287dcd128d7f9dcd718eda1f25dd6837dddb6aa37b71d7eb187bcbd55a578e  /tmp/bitnami/pkg/cache/mysqld-exporter-0.12.1-0-linux-x86_64-centos-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/mysqld-exporter-0.12.1-0-linux-x86_64-centos-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/mysqld-exporter-0.12.1-0-linux-x86_64-centos-7.tar.gz
RUN ln -sf /opt/bitnami/mysqld-exporter/bin/mysqld_exporter /bin/mysqld_exporter

ENV BITNAMI_APP_NAME="mysqld-exporter" \
    BITNAMI_IMAGE_VERSION="0.12.1-centos-7-r49" \
    PATH="/opt/bitnami/mysqld-exporter/bin:$PATH"

EXPOSE 9104

WORKDIR /opt/bitnami/mysqld-exporter
USER 1001
ENTRYPOINT [ "mysqld_exporter" ]
