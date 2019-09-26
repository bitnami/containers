FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kube-state-metrics-1.7.2-1-linux-amd64-debian-9.tar.gz && \
    echo "ce735f4be93b058b0bff919f6877a839a5204572f43e46b8559664d35f39b05f  /tmp/bitnami/pkg/cache/kube-state-metrics-1.7.2-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kube-state-metrics-1.7.2-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kube-state-metrics-1.7.2-1-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="kube-state-metrics" \
    BITNAMI_IMAGE_VERSION="1.7.2-debian-9-r53" \
    PATH="/opt/bitnami/kube-state-metrics/bin:$PATH"

EXPOSE 8080 8081

WORKDIR /opt/bitnami/kube-state-metrics
USER 1001
ENTRYPOINT [ "kube-state-metrics", "--port=8080", "--telemetry-port=8081" ]
