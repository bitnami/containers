FROM bitnami/minideb-extras:jessie-r13
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.4.3-r0 \
    BITNAMI_APP_NAME=mongodb \
    PATH=/opt/bitnami/mongodb/bin:$PATH

# System packages required
RUN install_packages libssl1.0.0 libc6 libgcc1 libpcap0.8

# Install mongodb
RUN bitnami-pkg unpack mongodb-3.4.3-0 --checksum fff6b5aa7485a84ca8e0ed9533334e684cd519c7feb0ddb1fa154052f2f7cade

COPY rootfs/ /

ENV MONGODB_ROOT_PASSWORD= \
    MONGODB_USERNAME= \
    MONGODB_PASSWORD= \
    MONGODB_DATABASE= \
    MONGODB_REPLICA_SET_MODE= \
    MONGODB_REPLICA_SET_NAME="replicaset" \
    MONGODB_REPLICA_SET_KEY= \
    MONGODB_PRIMARY_HOST= \
    MONGODB_PRIMARY_PORT=27017 \
    MONGODB_PRIMARY_ROOT_USER=root \
    MONGODB_PRIMARY_ROOT_PASSWORD=

VOLUME ["/bitnami/mongodb"]

EXPOSE 27017

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/run.sh"]
