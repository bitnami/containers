FROM bitnami/minideb-extras:jessie-r38
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libpcap0.8 libssl1.0.0
RUN bitnami-pkg unpack mongodb-3.7.5-0 --checksum edaad223b3c3afbf65bac685c4a1a1066097138be6ccc290b41cc5673068ac1e

COPY rootfs /
ENV BITNAMI_APP_NAME="mongodb" \
    BITNAMI_IMAGE_VERSION="3.7.5-r3" \
    MONGODB_ADVERTISED_HOSTNAME="" \
    MONGODB_DATABASE="" \
    MONGODB_PASSWORD="" \
    MONGODB_PRIMARY_HOST="" \
    MONGODB_PRIMARY_PORT_NUMBER="27017" \
    MONGODB_PRIMARY_ROOT_PASSWORD="" \
    MONGODB_PRIMARY_ROOT_USER="root" \
    MONGODB_REPLICA_SET_KEY="" \
    MONGODB_REPLICA_SET_MODE="" \
    MONGODB_REPLICA_SET_NAME="replicaset" \
    MONGODB_ROOT_PASSWORD="" \
    MONGODB_USERNAME="" \
    PATH="/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
