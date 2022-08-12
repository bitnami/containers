FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.4.0-debian-11-r30" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/prometheus-rsocket-proxy" \
      org.opencontainers.image.title="prometheus-rsocket-proxy" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.4.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc-s1 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.345-1-linux-amd64-debian-11.tar.gz && \
    echo "4d90bf2066c8d6605ac771e9b97c1188f4491d458fcb56956eeead6a18f70ac4  /tmp/bitnami/pkg/cache/java-1.8.345-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.345-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.345-1-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-rsocket-proxy-1.4.0-153-linux-amd64-debian-11.tar.gz && \
    echo "0b9a164da0fedf922cf15d3a70ec17846f0a8e38d301caf40e985c78cac94c46  /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.4.0-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.4.0-153-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.4.0-153-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN touch /opt/bitnami/prometheus-rsocket-proxy/prometheus-rsocket-proxy.log && chmod -R g+rwX /opt/bitnami/prometheus-rsocket-proxy

ENV APP_VERSION="1.4.0" \
    BITNAMI_APP_NAME="prometheus-rsocket-proxy" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/prometheus-rsocket-proxy
USER 1001
ENTRYPOINT [ "/opt/bitnami/java/bin/java", "-jar", "/opt/bitnami/prometheus-rsocket-proxy/prometheus-rsocket-proxy.jar" ]
