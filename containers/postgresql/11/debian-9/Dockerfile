FROM bitnami/minideb-extras:stretch-r217
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libbsd0 libc6 libedit2 libgcc1 libicu57 liblzma5 libncurses5 libnss-wrapper libssl1.1 libstdc++6 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack postgresql-11.1.0-1 --checksum 04557f61ce24b19e9f97c3dc04cc55a59192f01addb2ba7a484e61b35b6843d4
RUN mkdir /docker-entrypoint-initdb.d /opt/bitnami/postgresql/conf/
RUN chmod -R g+rwX /opt/bitnami/postgresql/conf/

COPY rootfs /
ENV BITNAMI_APP_NAME="postgresql" \
    BITNAMI_IMAGE_VERSION="11.1.0-debian-9-r21" \
    NAMI_PREFIX="/.nami" \
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

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
