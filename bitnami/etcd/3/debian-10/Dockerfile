FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/etcd/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "etcd" "3.5.0-2" --checksum c06627e50e2f38500a5d113255e66c8b564e1533d3832f85e1a9fef1aaad03b5
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/etcd/postunpack.sh
ENV BITNAMI_APP_NAME="etcd" \
    BITNAMI_IMAGE_VERSION="3.5.0-debian-10-r46" \
    ETCDCTL_API="3"

EXPOSE 2379 2380

WORKDIR /opt/bitnami/etcd
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/etcd/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/etcd/run.sh" ]
