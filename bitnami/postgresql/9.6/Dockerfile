FROM bitnami/minideb-extras:jessie-r17
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libbsd0 libc6 libedit2 liblzma5 libssl1.0.0 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack postgresql-9.6.3-2 --checksum a60abef33117c892881011ece1b5c237712673d93a1e176ee98caee30faef0e9

COPY rootfs /

ENV BITNAMI_APP_NAME="postgresql" \
    BITNAMI_IMAGE_VERSION="9.6.3-r3" \
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



VOLUME ["/bitnami/postgresql"]

EXPOSE 5432

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","postgresql"]
