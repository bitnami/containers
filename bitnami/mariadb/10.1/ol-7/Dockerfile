FROM bitnami/oraclelinux-extras-base:7-r437
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages audit-libs glibc keyutils-libs krb5-libs libaio libcap-ng libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pam pcre zlib
RUN . ./libcomponent.sh && component_unpack "mariadb" "10.1.41-4" --checksum 4d787a4f34735d241e445d3118fa458dadc98db72e37e1c673e9c49e608d00bb
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb" \
    BITNAMI_IMAGE_VERSION="10.1.41-ol-7-r75" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
