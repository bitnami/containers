FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.322-7-linux-amd64-debian-10.tar.gz && \
    echo "3ce0c1dc975421abe79ffa5d459b4562802312f299a86576d1a169fe2d38f5d9  /tmp/bitnami/pkg/cache/java-1.8.322-7-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.322-7-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.322-7-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-rsocket-proxy-1.3.0-8-linux-amd64-debian-10.tar.gz && \
    echo "7021f707506b0dc8eaf041f43332a3a64a5a2243cf51935aa5f9471e4b50614a  /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.3.0-8-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.3.0-8-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-rsocket-proxy-1.3.0-8-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN touch /opt/bitnami/prometheus-rsocket-proxy/prometheus-rsocket-proxy.log && chmod -R g+rwX /opt/bitnami/prometheus-rsocket-proxy

ENV BITNAMI_APP_NAME="prometheus-rsocket-proxy" \
    BITNAMI_IMAGE_VERSION="1.3.0-debian-10-r416" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/prometheus-rsocket-proxy
USER 1001
ENTRYPOINT [ "/opt/bitnami/java/bin/java", "-jar", "/opt/bitnami/prometheus-rsocket-proxy/prometheus-rsocket-proxy.jar" ]
