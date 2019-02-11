FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/etcd-3.3.12-0-linux-amd64-debian-9.tar.gz && \
    echo "19561bb1a23d3afe8b62b4de6a90b20cb66eda4b7a1855fde5beccd6bcda378c  /tmp/bitnami/pkg/cache/etcd-3.3.12-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/etcd-3.3.12-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/etcd-3.3.12-0-linux-amd64-debian-9.tar.gz

COPY rootfs /
RUN chmod g+rwX /opt/bitnami/etcd
ENV BITNAMI_APP_NAME="etcd" \
    BITNAMI_IMAGE_VERSION="3.3.12-debian-9-r1" \
    ETCD_ADVERTISE_CLIENT_URLS="http://127.0.0.1:2379" \
    ETCD_DATA_DIR="/opt/bitnami/etcd/data/" \
    ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379" \
    PATH="/opt/bitnami/etcd/bin:$PATH"

EXPOSE 2379 2380

WORKDIR /opt/bitnami/etcd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "etcd" ]
