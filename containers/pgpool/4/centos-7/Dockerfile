FROM bitnami/centos-extras-base:7-r189
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages audit-libs glibc keyutils-libs krb5-libs libcap-ng libcom_err libedit libgcc libicu libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nss-pam-ldapd nss-softokn-freebl openldap openldap-clients openssl-libs pam pcre xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.10.0-1" --checksum 047268e6ed6f6f0a0601b1bef2cdd6fb3bfbca0f22e598940e71848e975d931b
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.1.0-0" --checksum 8c226354d202ca21a8acdbe166a80930d3ce8406ec6f8ce3f00237bc295b7c62

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.1.0-centos-7-r1" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
