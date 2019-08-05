FROM bitnami/oraclelinux-extras-base:7-r368
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libaio libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl pcre
RUN . ./libcomponent.sh && component_unpack "mysql" "5.7.27-0" --checksum 7c0aec313965b318256c723fc4bedc76cc7f585813903259becdc39da944ed63
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="mysql" \
    BITNAMI_IMAGE_VERSION="5.7.27-ol-7-r15" \
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
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mysql/bin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
