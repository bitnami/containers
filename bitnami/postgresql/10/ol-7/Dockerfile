FROM bitnami/oraclelinux-extras:7-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libselinux libxml2 libxslt ncurses-libs nss-softokn-freebl openssl-libs pcre readline xz-libs zlib
RUN bitnami-pkg unpack postgresql-10.4.0-1 --checksum 82488dd9ed148faf3601a9373571afed98c477a9ca5cc30ed2c2979ad926115c

COPY rootfs /
ENV BITNAMI_APP_NAME="postgresql" \
    BITNAMI_IMAGE_VERSION="10.4.0-ol-7-r6" \
    PATH="/opt/bitnami/postgresql/bin:$PATH" \
    POSTGRESQL_DATABASE="" \
    POSTGRESQL_MASTER_HOST="" \
    POSTGRESQL_MASTER_PORT_NUMBER="5432" \
    POSTGRESQL_PASSWORD="" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_REPLICATION_MODE="master" \
    POSTGRESQL_REPLICATION_PASSWORD="" \
    POSTGRESQL_REPLICATION_USER="" \
    POSTGRESQL_USERNAME="postgres"

EXPOSE 5432

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","postgresql"]
