FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.3.8-debian-11-r32" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/cassandra-exporter" \
      org.opencontainers.image.title="cassandra-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.3.8"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f java-11.0.15-1-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/java-11.0.15-1-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "7214b8ab81c9d919f87f027590ca80c198f65fe50c5e2886d8e5e20691aee8d7  java-11.0.15-1-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf java-11.0.15-1-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf java-11.0.15-1-3-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f cassandra-exporter-2.3.8-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/cassandra-exporter-2.3.8-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "d6c196123e9c463c1faef12fb1d72484229a9e24806c7dccf60c126221c4e81b  cassandra-exporter-2.3.8-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf cassandra-exporter-2.3.8-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf cassandra-exporter-2.3.8-154-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="2.3.8" \
    BITNAMI_APP_NAME="cassandra-exporter" \
    PATH="/opt/bitnami/java/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/cassandra-exporter
USER 1001
ENTRYPOINT [ "java", "-jar", "./cassandra_exporter.jar", "./config.yml" ]
