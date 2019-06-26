FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kube-state-metrics-1.6.0-0-linux-amd64-debian-9.tar.gz && \
    echo "06e162e0aa810bae402fecfdc1bdc49f68db46b8df179ded72637b66cc2f83e3  /tmp/bitnami/pkg/cache/kube-state-metrics-1.6.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kube-state-metrics-1.6.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kube-state-metrics-1.6.0-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="kube-state-metrics" \
    BITNAMI_IMAGE_VERSION="1.6.0-debian-9-r46" \
    PATH="/opt/bitnami/kube-state-metrics/bin:$PATH"

EXPOSE 8080 8081

WORKDIR /opt/bitnami/kube-state-metrics
USER 1001
ENTRYPOINT [ "kube-state-metrics", "--port=8080", "--telemetry-port=8081" ]
