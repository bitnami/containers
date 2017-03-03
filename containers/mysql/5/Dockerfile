FROM gcr.io/stacksmith-images/minideb:jessie-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=5.7.17-r4 \
    BITNAMI_APP_NAME=mysql \
    PATH=/opt/bitnami/mysql/sbin:/opt/bitnami/mysql/bin:$PATH

# System packages required
RUN install_packages libc6 libstdc++6 libgcc1 libncurses5 libtinfo5 zlib1g libssl1.0.0 libaio1

# Install mysql
RUN bitnami-pkg unpack mysql-5.7.17-1 --checksum 4fee2983552c054189128e251044a062b85583d3f2da4522b32d4e4137a3115f

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
