FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip ldap-utils libaudit1 libbsd0 libc6 libcap-ng0 libedit2 libffi6 libgcc1 libgmp10 libgnutls30 libhogweed4 libicu63 libidn2-0 libldap-2.4-2 liblzma5 libnettle6 libnss-ldapd libp11-kit0 libpam-ldapd libpam0g libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 nslcd procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "10.17.0-0" --checksum b1c2a23c7d904b8968f8264dbbe0816cb1d6f5475cce3da620f823752c129266
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-3" --checksum 7521d9a4f9e4e182bf32977e234026caa7b03759799868335bccb1edd8f8fd12
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "pgpool" "4.2.3-0" --checksum dd48565736e3e9f58e885c0eb62098a422bb117f3922502e342fdf279e4a5a92
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/pgpool/postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.2.3-debian-10-r0" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/common/bin:/opt/bitnami/pgpool/bin:$PATH" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_NAME="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME="" \
    POSTGRESQL_HOST="postgresql" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_ROOT_PASSWORD="" \
    POSTGRESQL_ROOT_USER="postgres"

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/pgpool/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/pgpool/run.sh" ]
