FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.13.7-debian-11-r1" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/istio-pilot" \
      org.opencontainers.image.title="istio-pilot" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.13.7"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f istio-pilot-1.13.7-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/istio-pilot-1.13.7-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "51258cf4718cd74b4131612fffab85982716eefc50a49980a5d9a0b5375747b8  istio-pilot-1.13.7-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf istio-pilot-1.13.7-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf istio-pilot-1.13.7-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.13.7" \
    BITNAMI_APP_NAME="istio-pilot" \
    PATH="/opt/bitnami/istio/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/istio/bin/pilot-discovery" ]
