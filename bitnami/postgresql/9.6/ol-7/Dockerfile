FROM bitnami/oraclelinux-extras:7-r274
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libedit libselinux libxml2 libxslt ncurses-libs nss-softokn-freebl openssl-libs pcre xz-libs zlib
RUN bitnami-pkg unpack postgresql-9.6.12-0 --checksum e3cb32e2a486ac0602b04a8ad1ef65a18d4d9218fc81ca271ac00ffcbc99238c
RUN mkdir /docker-entrypoint-initdb.d /opt/bitnami/postgresql/conf/
RUN chmod -R g+rwX /opt/bitnami/postgresql/conf/

COPY rootfs /
RUN rpm -Uvh --nodeps $(repoquery --location nss_wrapper)
ENV BITNAMI_APP_NAME="postgresql" \
    BITNAMI_IMAGE_VERSION="9.6.12-ol-7-r12" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/postgresql/bin:$PATH" \
    POSTGRESQL_CLUSTER_APP_NAME="walreceiver" \
    POSTGRESQL_DATABASE="" \
    POSTGRESQL_DATA_DIR="/bitnami/postgresql" \
    POSTGRESQL_INITDB_ARGS="" \
    POSTGRESQL_INITDB_WALDIR="" \
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
