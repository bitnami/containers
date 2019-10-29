FROM bitnami/oraclelinux-extras-base:7-r463
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libedit libgcc libicu libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs openssl-libs pcre sqlite xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql-repmgr" "11.5.0-1" --checksum b1a6e5fd1d15b9b680a6d16d96f0ea6341123acc9d11443ce5c4c8c121d8881a

COPY rootfs /
RUN rpm -Uvh --nodeps $(repoquery --location nss_wrapper)
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="postgresql-repmgr" \
    BITNAMI_IMAGE_VERSION="11.5.0-ol-7-r23" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_LIB="/usr/lib64/libnss_wrapper.so" \
    PATH="/opt/bitnami/postgresql-repmgr/bin:/opt/bitnami/repmgr/bin:/opt/bitnami/postgresql/bin:$PATH"

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
