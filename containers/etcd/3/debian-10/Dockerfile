FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/etcd-3.4.7-0-linux-amd64-debian-10.tar.gz && \
    echo "f3bc35da5752c865698b34e13dc9bbd76e5c25af4fe57c503e643619094b44be  /tmp/bitnami/pkg/cache/etcd-3.4.7-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/etcd-3.4.7-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/etcd-3.4.7-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN mkdir -p /bitnami/etcd/data/ && chmod g+rwX /bitnami/etcd/data/
RUN chmod g+rwX /opt/bitnami/etcd
ENV BITNAMI_APP_NAME="etcd" \
    BITNAMI_IMAGE_VERSION="3.4.7-debian-10-r43" \
    ETCDCTL_API="3" \
    ETCD_ADVERTISE_CLIENT_URLS="http://127.0.0.1:2379" \
    ETCD_DATA_DIR="/bitnami/etcd/data/" \
    ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/etcd/bin:$PATH"

EXPOSE 2379 2380

WORKDIR /opt/bitnami/etcd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "etcd" ]
