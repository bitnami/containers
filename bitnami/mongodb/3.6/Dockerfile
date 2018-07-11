FROM bitnami/minideb-extras:jessie-r100
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libpcap0.8 libsasl2-2 libssl1.0.0
RUN bitnami-pkg unpack mongodb-3.6.6-0 --checksum 3f382bb9f2958d0cb35916b92d530696d810792fb597a923393bba5b8254182d

COPY rootfs /
ENV BITNAMI_APP_NAME="mongodb" \
    BITNAMI_IMAGE_VERSION="3.6.6-debian-8-r2" \
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
