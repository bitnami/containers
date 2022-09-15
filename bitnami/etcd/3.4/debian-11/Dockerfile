FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="3.4.21-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/etcd" \
      org.opencontainers.image.title="etcd" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.4.21"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f yq-4.27.5-0-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/yq-4.27.5-0-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/yq-4.27.5-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c yq-4.27.5-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf yq-4.27.5-0-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf yq-4.27.5-0-linux-${OS_ARCH}-debian-11.tar.gz yq-4.27.5-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz gosu-1.14.0-154-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f etcd-3.4.21-0-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/etcd-3.4.21-0-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/etcd-3.4.21-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c etcd-3.4.21-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf etcd-3.4.21-0-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf etcd-3.4.21-0-linux-${OS_ARCH}-debian-11.tar.gz etcd-3.4.21-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/etcd/postunpack.sh
ENV APP_VERSION="3.4.21" \
    BITNAMI_APP_NAME="etcd" \
    ETCDCTL_API="3" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/etcd/bin:$PATH"

EXPOSE 2379 2380

WORKDIR /opt/bitnami/etcd
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/etcd/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/etcd/run.sh" ]
