FROM bitnami/minideb-extras:stretch-r70
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbsd0 libc6 libedit2 libgcc1 libicu57 liblzma5 libncurses5 libssl1.1 libstdc++6 libtinfo5 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack postgresql-10.4.0-2 --checksum 400a1c851c784f2c4ea2c0fcfe5da7307195bbf96023f49f6e69077e06cddf86

COPY rootfs /
ENV BITNAMI_APP_NAME="postgresql" \
    BITNAMI_IMAGE_VERSION="10.4.0-debian-9-r2" \
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
