FROM bitnami/oraclelinux-extras:7-r34
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libaio libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre zlib
RUN bitnami-pkg unpack mysql-8.0.11-0 --checksum b6fbece5dd896e119a7f524c5ddcbda50b79d330552df9862d1cd0ceb653bf37

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="mysql" \
    BITNAMI_IMAGE_VERSION="8.0.11-ol-7-r17" \
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
    PATH="/opt/bitnami/mysql/bin:$PATH"

EXPOSE 3306

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","mysql"]
