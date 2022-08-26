FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.13.7-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/istio-proxyv2" \
      org.opencontainers.image.title="istio-proxyv2" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.13.7"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f envoy-1.22.5-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/envoy-1.22.5-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "fa9ada6acb45636407c999ffcaf00c629d94a22754906f4cbcf6c85dfee0a7a1  envoy-1.22.5-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf envoy-1.22.5-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf envoy-1.22.5-0-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f istio-proxyv2-1.13.7-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/istio-proxyv2-1.13.7-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "f514bf1e790413e1b58f32cb937cb616f7580941b5bd6cca57aabe402bacd65a  istio-proxyv2-1.13.7-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf istio-proxyv2-1.13.7-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf istio-proxyv2-1.13.7-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.13.7" \
    BITNAMI_APP_NAME="istio-proxyv2" \
    PATH="/opt/bitnami/envoy/bin:/opt/bitnami/istio/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/istio/bin/pilot-agent" ]
