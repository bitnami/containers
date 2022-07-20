FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip ldap-utils libaudit1 libbsd0 libc6 libcap-ng0 libcrypt1 libedit2 libffi7 libgcc-s1 libgmp10 libgnutls30 libhogweed6 libicu67 libidn2-0 libldap-2.4-2 libldap-common liblzma5 libmd0 libnettle8 libnss-ldapd libp11-kit0 libpam-ldapd libpam0g libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 nslcd procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "14.4.0-1" --checksum fe8d59603f65193e4a2a66459b7be62fde5548d7f5adca0297f24e0ce1b596da
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-152" --checksum 0694ae67645c416d9f6875e90c0f7cef379b4ac8030a6a5b8b5cc9ca77c6975d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "pgpool" "4.3.2-152" --checksum 75f7b44151a2cc47f08318a388b8d61ca980d912b9a8c437fbacd705440792fe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/pgpool/postunpack.sh
ENV APP_VERSION="4.3.2" \
    BITNAMI_APP_NAME="pgpool" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/common/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/pgpool/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/pgpool/run.sh" ]
