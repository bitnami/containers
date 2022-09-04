FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.15.0-debian-11-r19" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/chartmuseum" \
      org.opencontainers.image.title="chartmuseum" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.15.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab  gosu-1.14.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f chartmuseum-0.15.0-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/chartmuseum-0.15.0-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "f1cd104c5e529cd33e36f642de7e18b2205d7483a66b585ddf573666ca6dbdb9  chartmuseum-0.15.0-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf chartmuseum-0.15.0-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf chartmuseum-0.15.0-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/chartmuseum/postunpack.sh
ENV APP_VERSION="0.15.0" \
    BITNAMI_APP_NAME="chartmuseum" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/chartmuseum/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/chartmuseum/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/chartmuseum/run.sh" ]
