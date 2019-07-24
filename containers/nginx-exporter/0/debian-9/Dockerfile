FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nginx-exporter-0.4.2-0-linux-amd64-debian-9.tar.gz && \
    echo "a1ce2b30f93d8e0112e40efdafb823aa52d0e6bace01cd139203c1702617a9a3  /tmp/bitnami/pkg/cache/nginx-exporter-0.4.2-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nginx-exporter-0.4.2-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nginx-exporter-0.4.2-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="nginx-exporter" \
    BITNAMI_IMAGE_VERSION="0.4.2-debian-9-r1" \
    PATH="/opt/bitnami/nginx-exporter/bin:$PATH"

EXPOSE 9113

WORKDIR /opt/bitnami/nginx-exporter
USER 1001
ENTRYPOINT [ "nginx-prometheus-exporter" ]
