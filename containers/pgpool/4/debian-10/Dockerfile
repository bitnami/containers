FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip ldap-utils libaudit1 libbsd0 libc6 libcap-ng0 libedit2 libffi6 libgcc1 libgmp10 libgnutls30 libhogweed4 libicu63 libidn2-0 libldap-2.4-2 liblzma5 libnettle6 libnss-ldapd libp11-kit0 libpam-ldapd libpam0g libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 nslcd procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "10.13.0-1" --checksum ac5c3f62281e4a336b7fed8839dcf35b892f26e52a981463909bb2c6ebc5775b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-1" --checksum 07c4678654b01811f22b5bb65a8d6f8e253abd4524ebb3b78c7d3df042cf23bd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "pgpool" "4.1.2-0" --checksum 3c4c054688bf305a2401b929efa627dcd9862bb7ab0b96ce935d4f4bce52ffd5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-1" --checksum 51cfb1b7fd7b05b8abd1df0278c698103a9b1a4964bdacd87ca1d5c01631d59c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/pgpool/postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.1.2-debian-10-r38" \
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
