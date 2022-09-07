FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.5.0-debian-11-r21" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kong-ingress-controller" \
      org.opencontainers.image.title="kong-ingress-controller" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.5.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f wait-for-port-1.0.3-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/wait-for-port-1.0.3-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "74a09c2208af7316f32ee3ee8479d70b20ad54f1a989e84b6417e23c1f07c147  wait-for-port-1.0.3-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf wait-for-port-1.0.3-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf wait-for-port-1.0.3-154-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kong-ingress-controller-2.5.0-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kong-ingress-controller-2.5.0-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e007e194ec0515ef7160d98e5cac1d3f5586500555c2fd684fefc1d513027c92  kong-ingress-controller-2.5.0-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kong-ingress-controller-2.5.0-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf kong-ingress-controller-2.5.0-3-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="2.5.0" \
    BITNAMI_APP_NAME="kong-ingress-controller" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kong-ingress-controller/bin:$PATH"

USER 1001
ENTRYPOINT [ "kong-ingress-controller" ]
CMD [ "--help" ]
