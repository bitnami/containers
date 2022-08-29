FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.6.1-debian-11-r14" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/promtail" \
      org.opencontainers.image.title="promtail" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.6.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f promtail-2.6.1-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/promtail-2.6.1-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "d0df301a461f976cd829c96bfa898b53badd00df49850b8d15ecc561e330f1cf  promtail-2.6.1-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf promtail-2.6.1-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf promtail-2.6.1-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="2.6.1" \
    BITNAMI_APP_NAME="promtail" \
    PATH="/opt/bitnami/promtail/bin:$PATH"

USER 1001
ENTRYPOINT [ "promtail" ]
