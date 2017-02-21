FROM gcr.io/stacksmith-images/minideb:jessie-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=5.7.17-r3 \
    BITNAMI_APP_NAME=mysql \
    PATH=/opt/bitnami/mysql/sbin:/opt/bitnami/mysql/bin:$PATH

# System packages required
RUN install_packages libc6 libstdc++6 libgcc1 libncurses5 libtinfo5 zlib1g libssl1.0.0 libaio1

# Install mysql
RUN bitnami-pkg unpack mysql-5.7.17-0 --checksum ad640d43fdd209885f3283961e5f3c2e9a877b32f0a22a59f5c070bf2ae31edf

COPY rootfs /

ENV MYSQL_ROOT_PASSWORD= \
    MYSQL_USER= \
    MYSQL_PASSWORD= \
    MYSQL_DATABASE= \
    MYSQL_PORT= \
    MYSQL_REPLICATION_MODE= \
    MYSQL_REPLICATION_USER= \
    MYSQL_REPLICATION_PASSWORD= \
    MYSQL_MASTER_HOST= \
    MYSQL_MASTER_PORT=3306 \
    MYSQL_MASTER_USER=root \
    MYSQL_MASTER_PASSWORD=

VOLUME ["/bitnami/mysql"]

EXPOSE 3306

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "mysql"]
