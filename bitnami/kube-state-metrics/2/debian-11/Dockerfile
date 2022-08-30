FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.6.0-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kube-state-metrics" \
      org.opencontainers.image.title="kube-state-metrics" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.6.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kube-state-metrics-2.6.0-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kube-state-metrics-2.6.0-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "3ec94f4f336982549fbc5e33430f34c5efe7196947df0ff56a1ad8ee6b3b939b  kube-state-metrics-2.6.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kube-state-metrics-2.6.0-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf kube-state-metrics-2.6.0-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="2.6.0" \
    BITNAMI_APP_NAME="kube-state-metrics" \
    PATH="/opt/bitnami/kube-state-metrics/bin:$PATH"

EXPOSE 8080 8081

WORKDIR /opt/bitnami/kube-state-metrics
USER 1001
ENTRYPOINT [ "kube-state-metrics", "--port=8080", "--telemetry-port=8081" ]
