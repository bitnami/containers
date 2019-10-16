FROM bitnami/centos-extras-base:7-r173
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages audit-libs glibc keyutils-libs krb5-libs libcap-ng libcom_err libedit libgcc libicu libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nss-pam-ldapd nss-softokn-freebl openldap openldap-clients openssl-libs pam pcre xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.10.0-1" --checksum 047268e6ed6f6f0a0601b1bef2cdd6fb3bfbca0f22e598940e71848e975d931b
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.0.6-1" --checksum 5270b551fe3ae85910d7ee0d1529738473df481ef3ca7a41c2aa6bdc34163e2d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.0.6-centos-7-r48" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
