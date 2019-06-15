FROM bitnami/minideb-extras:stretch-r391
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libpcap0.8 libssl1.1
RUN bitnami-pkg unpack mongodb-3.6.13-0 --checksum acf047501763fc558d60c0f01ed515479d8541fc0b2573914f5e6a86e6a35386
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
ENV BITNAMI_APP_NAME="mongodb" \
    BITNAMI_IMAGE_VERSION="3.6.13-debian-9-r9" \
    MONGODB_ADVERTISED_HOSTNAME="" \
    MONGODB_DATABASE="" \
    MONGODB_DISABLE_SYSTEM_LOG="no" \
    MONGODB_ENABLE_DIRECTORY_PER_DB="no" \
    MONGODB_ENABLE_IPV6="yes" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_PRIMARY_HOST="" \
    MONGODB_PRIMARY_PORT_NUMBER="27017" \
    MONGODB_PRIMARY_ROOT_PASSWORD="" \
    MONGODB_PRIMARY_ROOT_USER="root" \
    MONGODB_REPLICA_SET_KEY="" \
    MONGODB_REPLICA_SET_MODE="" \
    MONGODB_REPLICA_SET_NAME="replicaset" \
    MONGODB_ROOT_PASSWORD="" \
    MONGODB_SYSTEM_LOG_VERBOSITY="0" \
    MONGODB_USERNAME="" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
