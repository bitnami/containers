FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/airflow-exporter-0.20180711.0-2-linux-amd64-debian-10.tar.gz && \
    echo "28cb1b29059e5abddd5b2813c1e91637ebc7f165002fdb4d1af42df8c03f1b08  /tmp/bitnami/pkg/cache/airflow-exporter-0.20180711.0-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/airflow-exporter-0.20180711.0-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/airflow-exporter-0.20180711.0-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="airflow-exporter" \
    BITNAMI_IMAGE_VERSION="0.20180711.0-debian-10-r337" \
    PATH="/opt/bitnami/airflow-exporter/bin:$PATH"

EXPOSE 9112

WORKDIR /opt/bitnami/airflow-exporter
USER 1001
ENTRYPOINT [ "airflow-prometheus-exporter" ]
