FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/etcd-3.3.8-2-linux-amd64-debian-9.tar.gz && \
    echo "0b69367224369b4152c74e96315fad66cc51ce90c32022f1981f2d259cae1e2e  /tmp/bitnami/pkg/cache/etcd-3.3.8-2-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/etcd-3.3.8-2-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/etcd-3.3.8-2-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/etcd /opt/bitnami/etcd
ENV BITNAMI_APP_NAME="etcd" \
    BITNAMI_IMAGE_VERSION="3.3.8-debian-9-r7" \
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
