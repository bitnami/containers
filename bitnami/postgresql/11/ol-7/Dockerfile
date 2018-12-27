FROM bitnami/oraclelinux-extras:7-r210
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libselinux libxml2 libxslt ncurses-libs openssl-libs pcre readline xz-libs zlib
RUN bitnami-pkg unpack postgresql-11.1.0-26 --checksum 92132ec1537dfe54df7513b0f187a3e07f8d6496607195cba736c2f236fa9e58
RUN mkdir /docker-entrypoint-initdb.d /opt/bitnami/postgresql/conf/
RUN chmod -R g+rwX /opt/bitnami/postgresql/conf/

COPY rootfs /
RUN rpm -Uvh --nodeps $(repoquery --location nss_wrapper)
ENV BITNAMI_APP_NAME="postgresql" \
    BITNAMI_IMAGE_VERSION="11.1.0-ol-7-r51" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/postgresql/bin:$PATH" \
    POSTGRESQL_CLUSTER_APP_NAME="walreceiver" \
    POSTGRESQL_DATABASE="" \
    POSTGRESQL_MASTER_HOST="" \
    POSTGRESQL_MASTER_PORT_NUMBER="5432" \
    POSTGRESQL_NUM_SYNCHRONOUS_REPLICAS="0" \
    POSTGRESQL_PASSWORD="" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_REPLICATION_MODE="master" \
    POSTGRESQL_REPLICATION_PASSWORD="" \
    POSTGRESQL_REPLICATION_USER="" \
    POSTGRESQL_SYNCHRONOUS_COMMIT_MODE="on" \
    POSTGRESQL_USERNAME="postgres"

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
