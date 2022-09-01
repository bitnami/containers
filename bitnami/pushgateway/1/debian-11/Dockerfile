FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.4.3-debian-11-r33" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/pushgateway" \
      org.opencontainers.image.title="pushgateway" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.4.3"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f pushgateway-1.4.3-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/pushgateway-1.4.3-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "76a92a23475fe6df93707c9dd08cd36f5079b2cce34f815970899177f1089e65  pushgateway-1.4.3-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf pushgateway-1.4.3-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf pushgateway-1.4.3-154-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.4.3" \
    BITNAMI_APP_NAME="pushgateway" \
    PATH="/opt/bitnami/pushgateway/bin:$PATH"

EXPOSE 9091

WORKDIR /opt/bitnami/pushgateway
USER 1001
ENTRYPOINT [ "/opt/bitnami/pushgateway/bin/pushgateway" ]
