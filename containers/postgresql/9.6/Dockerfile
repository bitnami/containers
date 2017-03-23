FROM bitnami/minideb-extras:jessie-r13
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=9.6.2-r1 \
    BITNAMI_APP_NAME=postgresql \
    PATH=/opt/bitnami/postgresql/bin:$PATH

# System packages required
RUN install_packages libc6 libssl1.0.0 zlib1g libxml2 liblzma5 libedit2 libbsd0 libtinfo5 libxslt1.1

# Install postgresql
RUN bitnami-pkg unpack postgresql-9.6.2-0 --checksum b706396cc1a435741e4db319f8028d716047cc4d40e6b3418c16944f6661f90f

COPY rootfs /

ENV POSTGRESQL_USERNAME=postgres \
    POSTGRESQL_PASSWORD= \
    POSTGRESQL_DATABASE= \
    POSTGRESQL_REPLICATION_MODE=master \
    POSTGRESQL_REPLICATION_USER= \
    POSTGRESQL_REPLICATION_PASSWORD= \
    POSTGRESQL_MASTER_HOST= \
    POSTGRESQL_MASTER_PORT=5432

VOLUME ["/bitnami/postgresql"]

EXPOSE 5432

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "postgresql"]
