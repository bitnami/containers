FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/postgres-exporter-0.8.0-2-linux-amd64-debian-10.tar.gz && \
    echo "8dda8d17f70d111dc7cf0a51137b0ecf62e6db6fcfc057df1c78f9ac7e44b52c  /tmp/bitnami/pkg/cache/postgres-exporter-0.8.0-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/postgres-exporter-0.8.0-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/postgres-exporter-0.8.0-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="postgres-exporter" \
    BITNAMI_IMAGE_VERSION="0.8.0-debian-10-r324" \
    PATH="/opt/bitnami/postgres-exporter/bin:$PATH"

EXPOSE 9187

WORKDIR /opt/bitnami/postgres-exporter
USER 1001
ENTRYPOINT [ "postgres_exporter" ]
