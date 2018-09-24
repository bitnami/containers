FROM bitnami/minideb-extras:stretch-r148
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/mysql/conf" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libaio1 libatomic1 libc6 libgcc1 libncurses5 libsasl2-2 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg unpack mysql-5.7.23-4 --checksum d67c2a839278f091669c4ab4f1e89a661d7a75f8c0f62f3eb3be4ef805917367
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="mysql" \
    BITNAMI_IMAGE_VERSION="5.7.23-debian-9-r51" \
    MYSQL_DATABASE="" \
    MYSQL_MASTER_HOST="" \
    MYSQL_MASTER_PORT_NUMBER="" \
    MYSQL_MASTER_ROOT_PASSWORD="" \
    MYSQL_MASTER_ROOT_USER="" \
    MYSQL_PASSWORD="" \
    MYSQL_PORT_NUMBER="3306" \
    MYSQL_REPLICATION_MODE="" \
    MYSQL_REPLICATION_PASSWORD="" \
    MYSQL_REPLICATION_USER="" \
    MYSQL_ROOT_PASSWORD="" \
    MYSQL_ROOT_USER="root" \
    MYSQL_USER="" \
    PATH="/opt/bitnami/mysql/bin:/opt/bitnami/mysql/sbin:$PATH" \
    USER="root"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
