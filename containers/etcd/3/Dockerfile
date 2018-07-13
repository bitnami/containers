FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/etcd-3.3.8-3-linux-x64-debian-8.tar.gz && \
    echo "36116bbf249b52c397128f33497b72ab1c878f10bd54ae13eb289a215b3f26c8  /tmp/bitnami/pkg/cache/etcd-3.3.8-3-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/etcd-3.3.8-3-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/etcd-3.3.8-3-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/etcd /opt/bitnami/etcd
ENV BITNAMI_APP_NAME="etcd" \
    BITNAMI_IMAGE_VERSION="3.3.8-debian-8-r16" \
    ETCD_ADVERTISE_CLIENT_URLS="http://127.0.0.1:2379" \
    ETCD_DATA_DIR="/opt/bitnami/etcd/data/" \
    ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379" \
    PATH="/opt/bitnami/etcd/bin:$PATH"

RUN install_packages ca-certificates
RUN chmod g+rwX /opt/bitnami/etcd

EXPOSE 2379 2380

COPY rootfs /
WORKDIR /opt/bitnami/etcd
USER 1001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["etcd"]
