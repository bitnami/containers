FROM bitnami/oraclelinux-extras:7-r57 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/etcd-3.3.9-1-linux-x86_64-ol-7.tar.gz && \
    echo "4b1082929add8c8ecfb7a3efb9de70525771b50f2566df5fb5eafe12ae098548  /tmp/bitnami/pkg/cache/etcd-3.3.9-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/etcd-3.3.9-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/etcd-3.3.9-1-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r57
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/etcd /opt/bitnami/etcd
ENV BITNAMI_APP_NAME="etcd" \
    BITNAMI_IMAGE_VERSION="3.3.9-ol-7-r3" \
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
