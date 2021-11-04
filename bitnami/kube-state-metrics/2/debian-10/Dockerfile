FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kube-state-metrics-2.2.3-0-linux-amd64-debian-10.tar.gz && \
    echo "0733a3a9831f4b6d6a2484ab42141e86c96e1a745935ea8c579c2c97b248d1a3  /tmp/bitnami/pkg/cache/kube-state-metrics-2.2.3-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kube-state-metrics-2.2.3-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kube-state-metrics-2.2.3-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="kube-state-metrics" \
    BITNAMI_IMAGE_VERSION="2.2.3-debian-10-r22" \
    PATH="/opt/bitnami/kube-state-metrics/bin:$PATH"

EXPOSE 8080 8081

WORKDIR /opt/bitnami/kube-state-metrics
USER 1001
ENTRYPOINT [ "kube-state-metrics", "--port=8080", "--telemetry-port=8081" ]
