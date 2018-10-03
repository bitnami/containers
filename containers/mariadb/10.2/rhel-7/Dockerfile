FROM gcr.io/helm-publish-ci/redhat-extras-base:7-r70
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="rhel-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libaio libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "mariadb" "10.2.18-1" --checksum 3fd9acb6dfb216e23bc41e90bd264ff1a9f9fdb2aefd48055c2a62eb55310a68
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /prepare.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="mariadb" \
    BITNAMI_IMAGE_VERSION="10.2.18-rhel-7-r3" \
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
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
