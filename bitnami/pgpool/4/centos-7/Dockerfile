FROM bitnami/centos-extras-base:7-r135
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages audit-libs glibc keyutils-libs krb5-libs libcap-ng libcom_err libedit libgcc libicu libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nss-pam-ldapd nss-softokn-freebl openldap openldap-clients openssl-libs pam pcre xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.10.0-0" --checksum 66ce2818f05685c875e22b703263363b6c051b61a3dfcce12d6b1bc1811ac5fa
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.0.6-0" --checksum a0e3a57a246b0a23515eec191ba60c07cce14aad147c8eafc1cd9467ad1af782

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.0.6-centos-7-r8" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
