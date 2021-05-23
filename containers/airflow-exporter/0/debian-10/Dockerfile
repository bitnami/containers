FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/airflow-exporter-0.20210126.0-0-linux-amd64-debian-10.tar.gz && \
    echo "24ebe2faffb181c5e35ac9a2c7ef1597f4cb486a03836cfd6c9158087dc22e70  /tmp/bitnami/pkg/cache/airflow-exporter-0.20210126.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/airflow-exporter-0.20210126.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/airflow-exporter-0.20210126.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="airflow-exporter" \
    BITNAMI_IMAGE_VERSION="0.20210126.0-debian-10-r110" \
    PATH="/opt/bitnami/airflow-exporter/bin:$PATH"

EXPOSE 9112

WORKDIR /opt/bitnami/airflow-exporter
USER 1001
ENTRYPOINT [ "airflow-prometheus-exporter" ]
