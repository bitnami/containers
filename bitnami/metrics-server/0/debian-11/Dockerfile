FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.6.1-debian-11-r34" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/metrics-server" \
      org.opencontainers.image.title="metrics-server" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.6.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f metrics-server-0.6.1-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/metrics-server-0.6.1-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "0fa1fa238f6586f9b79c5359363d5550864fb6afe4bcc1eb2fbc73e74089db6c  metrics-server-0.6.1-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf metrics-server-0.6.1-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf metrics-server-0.6.1-153-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

RUN chown -R 1001:root /opt/bitnami/metrics-server && chmod -R g+rwX /opt/bitnami/metrics-server
ENV APP_VERSION="0.6.1" \
    BITNAMI_APP_NAME="metrics-server" \
    PATH="/opt/bitnami/metrics-server/bin:$PATH"

EXPOSE 8443

WORKDIR /opt/bitnami/metrics-server
USER 1001
ENTRYPOINT [ "metrics-server", "--secure-port=8443", "--cert-dir=/opt/bitnami/metrics-server/certificates" ]
