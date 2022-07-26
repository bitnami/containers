FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc-s1 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.342-0-linux-amd64-debian-11.tar.gz && \
    echo "8f73ab6158f088f418caafcb5fd9981cf53076f38d8f9aba49acbcbadd6ac8da  /tmp/bitnami/pkg/cache/java-1.8.342-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.342-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.342-0-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-rsocket-proxy-1.4.0-152-linux-amd64-debian-11.tar.gz && \
    echo "8affe178f5ef4391b6fd3e2121f23a4135acff0ef9e86491456c6b4df50c87ec  /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.4.0-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.4.0-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.4.0-152-linux-amd64-debian-11.tar.gz
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
