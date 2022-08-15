FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.24.0-debian-11-r26" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/cluster-autoscaler" \
      org.opencontainers.image.title="cluster-autoscaler" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.24.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cluster-autoscaler-1.24.0-152-linux-amd64-debian-11.tar.gz && \
    echo "13ddc2555540202d4bd800a41db1f52ece4630a7c6fe4e9b3f275cf94631bd30  /tmp/bitnami/pkg/cache/cluster-autoscaler-1.24.0-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.24.0-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cluster-autoscaler-1.24.0-152-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/cluster-autoscaler/bin/cluster-autoscaler /opt/bitnami/cluster-autoscaler/cluster-autoscaler

COPY rootfs /
RUN chmod -R g+rwX /opt/bitnami/cluster-autoscaler/
ENV APP_VERSION="1.24.0" \
    BITNAMI_APP_NAME="cluster-autoscaler" \
    PATH="/opt/bitnami/cluster-autoscaler/bin:$PATH"

WORKDIR /opt/bitnami/cluster-autoscaler
USER 1001
CMD [ "/run.sh" ]
