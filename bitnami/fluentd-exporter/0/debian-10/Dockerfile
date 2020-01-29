FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps sudo unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-exporter-0.2.0-0-linux-amd64-debian-10.tar.gz && \
    echo "06dec7dae945d2408d8e06deb7b6644b60911cd39d6e49da2b6afc504370e3d8  /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="fluentd-exporter" \
    BITNAMI_IMAGE_VERSION="0.2.0-debian-10-r5" \
    PATH="/opt/bitnami/fluentd-exporter/bin:$PATH"

EXPOSE 9309

WORKDIR /opt/bitnami/fluentd-exporter
USER 1001
ENTRYPOINT [ "fluentd_exporter" ]
