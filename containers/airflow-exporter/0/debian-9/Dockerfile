FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/airflow-exporter-0.20180711.0-0-linux-amd64-debian-9.tar.gz && \
    echo "c86a844e8019b41c5610222bab4bd03490bb35ff010e459f05b64a1598103160  /tmp/bitnami/pkg/cache/airflow-exporter-0.20180711.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/airflow-exporter-0.20180711.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/airflow-exporter-0.20180711.0-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="airflow-exporter" \
    BITNAMI_IMAGE_VERSION="0.20180711.0-debian-9-r25" \
    PATH="/opt/bitnami/airflow-exporter/bin:$PATH"

EXPOSE 9112

WORKDIR /opt/bitnami/airflow-exporter
USER 1001
ENTRYPOINT [ "airflow-prometheus-exporter" ]
