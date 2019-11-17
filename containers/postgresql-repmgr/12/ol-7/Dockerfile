FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl cyrus-sasl-lib glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libedit libgcc libicu libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre procps-ng sqlite sudo tar which xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql-repmgr" "12.1.0-0" --checksum b653d8cbafe4cdd9b1e297d0a55778b42065b771e04a4e02ba1fb24c2bba9052

COPY rootfs /
RUN rpm -Uvh --nodeps $(repoquery --location nss_wrapper)
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="postgresql-repmgr" \
    BITNAMI_IMAGE_VERSION="12.1.0-ol-7-r3" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_LIB="/usr/lib64/libnss_wrapper.so" \
    PATH="/opt/bitnami/postgresql-repmgr/bin:/opt/bitnami/repmgr/bin:/opt/bitnami/postgresql/bin:$PATH"

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
