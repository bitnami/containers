FROM bitnami/minideb-extras:jessie-r14
MAINTAINER Bitnami <containers@bitnami.com>

# Install required system packages and dependencies
RUN install_packages libaio1 libc6 libgcc1 libncurses5 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg unpack mysql-5.7.18-0 --checksum b2937c5409ef168b3c655387c17b0b3e8e899ff5f1e617de85a2087890490437

COPY rootfs /

ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="mysql" \
    BITNAMI_IMAGE_VERSION="5.7.18-r2" \
    MYSQL_DATABASE="" \
    MYSQL_MASTER_HOST="" \
    MYSQL_MASTER_PORT="" \
    MYSQL_MASTER_ROOT_PASSWORD="" \
    MYSQL_MASTER_ROOT_USER="" \
    MYSQL_PASSWORD="" \
    MYSQL_PORT="3306" \
    MYSQL_REPLICATION_MODE="" \
    MYSQL_REPLICATION_PASSWORD="" \
    MYSQL_REPLICATION_USER="" \
    MYSQL_ROOT_PASSWORD="" \
    MYSQL_ROOT_USER="root" \
    MYSQL_USER="" \
    PATH="/opt/bitnami/mysql/bin:/opt/bitnami/mysql/sbin:$PATH"

VOLUME ["/bitnami/mysql"]

EXPOSE 3306

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","mysql"]
