FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/etcd-3.3.8-5-linux-amd64-debian-9.tar.gz && \
    echo "60e61786aab0507d8faa5e30cf4a9c9f1cf9d4be33ffe0b02d31c708bd964866  /tmp/bitnami/pkg/cache/etcd-3.3.8-5-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/etcd-3.3.8-5-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/etcd-3.3.8-5-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/etcd /opt/bitnami/etcd
ENV BITNAMI_APP_NAME="etcd" \
    BITNAMI_IMAGE_VERSION="3.3.8-debian-9-r22" \
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
