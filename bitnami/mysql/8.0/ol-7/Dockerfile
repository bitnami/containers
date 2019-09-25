FROM bitnami/oraclelinux-extras-base:7-r428
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libaio libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "mysql" "8.0.17-3" --checksum 56a329293877cdc764c0064e21edc8eaf2652488032bcb1e1c060f381bbf9746
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mysql" \
    BITNAMI_IMAGE_VERSION="8.0.17-ol-7-r67" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mysql/bin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
