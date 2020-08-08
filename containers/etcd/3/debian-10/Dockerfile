FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/etcd-3.4.10-2-linux-amd64-debian-10.tar.gz && \
    echo "17039fd7bd1d307bab04fe27a8d6e2c40c6107a0148be6305577a50adb9d0e5c  /tmp/bitnami/pkg/cache/etcd-3.4.10-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/etcd-3.4.10-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/etcd-3.4.10-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN mkdir -m 700 -p /bitnami/etcd/data/ && chown -R 1001 /bitnami/etcd/data/
RUN chmod g+rwX /opt/bitnami/etcd
ENV BITNAMI_APP_NAME="etcd" \
    BITNAMI_IMAGE_VERSION="3.4.10-debian-10-r10" \
    ETCDCTL_API="3" \
    ETCD_ADVERTISE_CLIENT_URLS="http://127.0.0.1:2379" \
    ETCD_DATA_DIR="/bitnami/etcd/data/" \
    ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379" \
    PATH="/opt/bitnami/etcd/bin:$PATH"

EXPOSE 2379 2380

WORKDIR /opt/bitnami/etcd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "etcd" ]
