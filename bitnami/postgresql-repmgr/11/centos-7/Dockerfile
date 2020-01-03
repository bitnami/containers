FROM bitnami/centos-extras-base:7-r257
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libedit libgcc libicu libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre sqlite xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql-repmgr" "11.6.0-2" --checksum de167d0df1faeaef96be544e68706affd8fe4e491fa5384ecc9f49636102f926

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="postgresql-repmgr" \
    BITNAMI_IMAGE_VERSION="11.6.0-centos-7-r55" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_LIB="/opt/bitnami/common/lib/libnss_wrapper.so" \
    PATH="/opt/bitnami/postgresql-repmgr/bin:/opt/bitnami/repmgr/bin:/opt/bitnami/postgresql/bin:$PATH"

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
