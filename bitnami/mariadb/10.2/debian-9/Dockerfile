FROM bitnami/minideb-extras-base:stretch-r283
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libaio1 libc6 libgcc1 libjemalloc1 libncurses5 libssl1.0.2 libstdc++6 libtinfo5 zlib1g
RUN . ./libcomponent.sh && component_unpack "mariadb" "10.2.25-1" --checksum 6921b2f9166db0a34dfdf5c81881de13065146da2f65a55287347600bc3198df
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="mariadb" \
    BITNAMI_IMAGE_VERSION="10.2.25-debian-9-r10" \
    MARIADB_DATABASE="" \
    MARIADB_MASTER_HOST="" \
    MARIADB_MASTER_PORT_NUMBER="" \
    MARIADB_MASTER_ROOT_PASSWORD="" \
    MARIADB_MASTER_ROOT_USER="" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_REPLICATION_MODE="" \
    MARIADB_REPLICATION_PASSWORD="" \
    MARIADB_REPLICATION_USER="" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MARIADB_USER="" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
