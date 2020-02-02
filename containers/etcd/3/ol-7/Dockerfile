FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip hostname libaio-devel procps-ng sudo tar wget which
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/etcd-3.4.3-0-linux-x86_64-ol-7.tar.gz && \
    echo "2c7dd3063e81a71b5ddfcc8f3b1c6fb7f42cf61b7dda552ae8d13c8da075c73c  /tmp/bitnami/pkg/cache/etcd-3.4.3-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/etcd-3.4.3-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/etcd-3.4.3-0-linux-x86_64-ol-7.tar.gz
RUN yum upgrade -y && \
    rm -r /var/cache/yum

COPY rootfs /
RUN chmod g+rwX /opt/bitnami/etcd
RUN mkdir -p /bitnami/etcd/data/ && chmod g+rwX /bitnami/etcd/data/
ENV BITNAMI_APP_NAME="etcd" \
    BITNAMI_IMAGE_VERSION="3.4.3-ol-7-r108" \
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
