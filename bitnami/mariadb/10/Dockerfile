FROM gcr.io/stacksmith-images/minideb:jessie-r11

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=10.1.22-r0 \
    BITNAMI_APP_NAME=mariadb \
    PATH=/opt/bitnami/mariadb/sbin:/opt/bitnami/mariadb/bin:$PATH

# System packages required
RUN install_packages libc6 libaio1 zlib1g libjemalloc1 libssl1.0.0 libstdc++6 libgcc1 libncurses5 libtinfo5

# Install mariadb
RUN bitnami-pkg unpack mariadb-10.1.22-0 --checksum a5f1a89807ee6b0989f2504c70f0a6f72f6517e6e79bce1cc7f3bacc8a9fd31b

COPY rootfs /

ENV MARIADB_ROOT_PASSWORD= \
    MARIADB_ROOT_USER=root \
    MARIADB_USER= \
    MARIADB_PASSWORD= \
    MARIADB_DATABASE= \
    MARIADB_PORT=3306 \
    MARIADB_REPLICATION_MODE= \
    MARIADB_REPLICATION_USER= \
    MARIADB_REPLICATION_PASSWORD= \
    MARIADB_MASTER_HOST= \
    MARIADB_MASTER_PORT= \
    MARIADB_MASTER_ROOT_USER= \
    MARIADB_MASTER_ROOT_PASSWORD= \
    ALLOW_EMPTY_PASSWORD=no

VOLUME ["/bitnami/mariadb"]

EXPOSE 3306

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "mariadb"]
