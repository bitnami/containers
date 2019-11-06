FROM bitnami/oraclelinux-extras-base:7-r471
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages audit-libs glibc keyutils-libs krb5-libs libcap-ng libcom_err libedit libgcc libicu libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nss-pam-ldapd nss-softokn-freebl openldap openldap-clients openssl-libs pam pcre xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.10.0-1" --checksum 24291521359e5224519371ea621712f55de4afd559abb7792c882c99c68e9120
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.1.0-0" --checksum 5908051d048dc81ce94cb68eca57488a582369858396c00cf3d455aa29f20be6

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.1.0-ol-7-r6" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
