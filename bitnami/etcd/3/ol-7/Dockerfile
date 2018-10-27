FROM bitnami/oraclelinux-extras:7-r150 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/etcd-3.3.10-1-linux-x86_64-ol-7.tar.gz && \
    echo "f7eabf9b734ec11d2e4986c390fd5525e5cb37e8c478caed99f9075e50cf469d  /tmp/bitnami/pkg/cache/etcd-3.3.10-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/etcd-3.3.10-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/etcd-3.3.10-1-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r150
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/etcd /opt/bitnami/etcd
ENV BITNAMI_APP_NAME="etcd" \
    BITNAMI_IMAGE_VERSION="3.3.10-ol-7-r19" \
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
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "etcd" ]
