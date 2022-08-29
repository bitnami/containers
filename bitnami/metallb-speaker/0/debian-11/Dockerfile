FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.13.4-debian-11-r13" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/metallb-speaker" \
      org.opencontainers.image.title="metallb-speaker" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.13.4"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f metallb-speaker-0.13.4-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/metallb-speaker-0.13.4-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e009399bbd164ee958ed284a5e1b15db1905bcd0a2829b43e06ed527d3ca11da  metallb-speaker-0.13.4-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf metallb-speaker-0.13.4-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf metallb-speaker-0.13.4-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.13.4" \
    BITNAMI_APP_NAME="metallb-speaker" \
    PATH="/opt/bitnami/metallb-speaker/bin:$PATH"

USER 1001
ENTRYPOINT [ "speaker" ]
CMD [ "--help" ]
