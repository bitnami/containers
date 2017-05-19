FROM bitnami/minideb-extras:jessie-r15
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbsd0 libc6 libedit2 liblzma5 libssl1.0.0 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack postgresql-9.6.3-0 --checksum 37ea09e6372c6a7637e096fd85003c213ac45e18e3aaed6da7f8957960bba43d

COPY rootfs /

ENV BITNAMI_APP_NAME="postgresql" \
    BITNAMI_IMAGE_VERSION="9.6.3-r0" \
    PATH="/opt/bitnami/postgresql/bin:$PATH" \
    POSTGRESQL_DATABASE="" \
    POSTGRESQL_MASTER_HOST="" \
    POSTGRESQL_MASTER_PORT="5432" \
    POSTGRESQL_PASSWORD="" \
    POSTGRESQL_PORT="5432" \
    POSTGRESQL_REPLICATION_MODE="master" \
    POSTGRESQL_REPLICATION_PASSWORD="" \
    POSTGRESQL_REPLICATION_USER="" \
    POSTGRESQL_USERNAME="postgres"

VOLUME ["/bitnami/postgresql"]

EXPOSE 5432

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","postgresql"]
