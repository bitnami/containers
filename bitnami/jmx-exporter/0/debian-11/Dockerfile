FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.17.0-debian-11-r30" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/jmx-exporter" \
      org.opencontainers.image.title="jmx-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.17.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc-s1 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f java-1.8.345-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/java-1.8.345-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "b244bc8c1f972d20fac8019cf97fb05ce6cd8be2034ca11f52243c8bd96aaa23  java-1.8.345-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf java-1.8.345-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf java-1.8.345-2-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f jmx-exporter-0.17.0-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/jmx-exporter-0.17.0-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "95857474dfa55e16573c24d3b7d66a679664db888d684665a6a00afce3db820c  jmx-exporter-0.17.0-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf jmx-exporter-0.17.0-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf jmx-exporter-0.17.0-153-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN chown -R 1001:1001 /opt/bitnami/jmx-exporter

ENV APP_VERSION="0.17.0" \
    BITNAMI_APP_NAME="jmx-exporter" \
    PATH="/opt/bitnami/java/bin:$PATH"

EXPOSE 5556

WORKDIR /opt/bitnami/jmx-exporter
USER 1001
ENTRYPOINT [ "java", "-jar", "jmx_prometheus_httpserver.jar" ]
CMD [ "5556", "example_configs/httpserver_sample_config.yml" ]
