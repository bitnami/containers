FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.31.3-debian-11-r2" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/trivy" \
      org.opencontainers.image.title="trivy" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.31.3"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f trivy-0.31.3-0-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/trivy-0.31.3-0-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "63cfb058c342d083415c4a6998a505a4ec91142a34147c421cdec0d901a4b96b  trivy-0.31.3-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf trivy-0.31.3-0-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf trivy-0.31.3-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.cache && chmod g+rwX /.cache

ENV APP_VERSION="0.31.3" \
    BITNAMI_APP_NAME="trivy" \
    PATH="/opt/bitnami/trivy/bin:$PATH"

USER 1001
ENTRYPOINT [ "trivy" ]
CMD [ "--help" ]
