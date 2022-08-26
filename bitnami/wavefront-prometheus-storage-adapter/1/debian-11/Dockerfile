FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.0.5-debian-11-r31" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/wavefront-prometheus-storage-adapter" \
      org.opencontainers.image.title="wavefront-prometheus-storage-adapter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.0.5"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    curl -SsLf https://downloads.bitnami.com/files/stacksmith/wavefront-prometheus-storage-adapter-1.0.5-152-linux-amd64-debian-11.tar.gz -o wavefront-prometheus-storage-adapter-1.0.5-152-linux-amd64-debian-11.tar.gz && \
    echo "28a94dc831eb69dc478d6872f456adb028c363c5dddf4732832e67fe528d8182  wavefront-prometheus-storage-adapter-1.0.5-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf wavefront-prometheus-storage-adapter-1.0.5-152-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf wavefront-prometheus-storage-adapter-1.0.5-152-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.0.5" \
    BITNAMI_APP_NAME="wavefront-prometheus-storage-adapter" \
    PATH="/opt/bitnami/wavefront-prometheus-storage-adapter/bin:$PATH"

USER 1001
ENTRYPOINT [ "adapter" ]
CMD [ "--help" ]
