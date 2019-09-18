FROM bitnami/oraclelinux-extras-base:7-r421
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages audit-libs glibc keyutils-libs krb5-libs libcap-ng libcom_err libedit libgcc libicu libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nss-pam-ldapd nss-softokn-freebl openldap openldap-clients openssl-libs pam pcre xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.10.0-0" --checksum 877059a02935507bb3c55ba60948dde36f7a0079cb4236abae325dbb5fde675a
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.0.6-0" --checksum 1b91c615d73dc6fef3f105a8566ddfc42ac2d14eee1cdb087651a3f1f4e153ed

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.0.6-ol-7-r18" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
