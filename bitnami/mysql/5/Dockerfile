FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=5.7.18-r0 \
    BITNAMI_APP_NAME=mysql \
    PATH=/opt/bitnami/mysql/sbin:/opt/bitnami/mysql/bin:$PATH

# System packages required
RUN install_packages libc6 libstdc++6 libgcc1 libncurses5 libtinfo5 zlib1g libssl1.0.0 libaio1

# Install mysql
RUN bitnami-pkg unpack mysql-5.7.18-0 --checksum b2937c5409ef168b3c655387c17b0b3e8e899ff5f1e617de85a2087890490437

COPY rootfs /

ENV MYSQL_ROOT_PASSWORD= \
    MYSQL_ROOT_USER=root \
    MYSQL_USER= \
    MYSQL_PASSWORD= \
    MYSQL_DATABASE= \
    MYSQL_PORT=3306 \
    MYSQL_REPLICATION_MODE= \
    MYSQL_REPLICATION_USER= \
    MYSQL_REPLICATION_PASSWORD= \
    MYSQL_MASTER_HOST= \
    MYSQL_MASTER_PORT= \
    MYSQL_MASTER_ROOT_USER= \
    MYSQL_MASTER_ROOT_PASSWORD= \
    ALLOW_EMPTY_PASSWORD=no

VOLUME ["/bitnami/mysql"]

EXPOSE 3306

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "mysql"]
