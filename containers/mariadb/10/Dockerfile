FROM gcr.io/stacksmith-images/minideb:jessie-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=10.1.21-r0 \
    BITNAMI_APP_NAME=mariadb \
    PATH=/opt/bitnami/mariadb/sbin:/opt/bitnami/mariadb/bin:$PATH

# System packages required
RUN install_packages libc6 libaio1 zlib1g libjemalloc1 libssl1.0.0 libstdc++6 libgcc1 libncurses5 libtinfo5

# Install mariadb
RUN bitnami-pkg unpack mariadb-10.1.21-0 --checksum ecf191e709c35881b69ff5aea22da984b6d05d4b751a0d5a72fa74bb02b71eea

COPY rootfs /

ENV MARIADB_ROOT_PASSWORD= \
    MARIADB_USER= \
    MARIADB_PASSWORD= \
    MARIADB_DATABASE= \
    MARIADB_PORT= \
    MARIADB_REPLICATION_MODE= \
    MARIADB_REPLICATION_USER= \
    MARIADB_REPLICATION_PASSWORD= \
    MARIADB_MASTER_HOST= \
    MARIADB_MASTER_PORT=3306 \
    MARIADB_MASTER_USER=root \
    MARIADB_MASTER_PASSWORD=

VOLUME ["/bitnami/mariadb"]

EXPOSE 3306

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "mariadb"]
