FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.12.2-debian-11-r13" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/external-dns" \
      org.opencontainers.image.title="external-dns" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.12.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f external-dns-0.12.2-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/external-dns-0.12.2-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "184e258e6dd59910322cb813ccffdb28671d270408e422209d6e311f9171cbc0  external-dns-0.12.2-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf external-dns-0.12.2-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf external-dns-0.12.2-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.12.2" \
    BITNAMI_APP_NAME="external-dns" \
    PATH="/opt/bitnami/external-dns/bin:$PATH"

EXPOSE 7979

WORKDIR /opt/bitnami/external-dns
USER 1001
ENTRYPOINT [ "external-dns" ]
