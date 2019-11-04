FROM bitnami/oraclelinux-extras-base:7-r469
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages audit-libs glibc keyutils-libs krb5-libs libaio libcap-ng libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pam pcre zlib
RUN . ./libcomponent.sh && component_unpack "mariadb" "10.1.41-5" --checksum 576386313f0332e8569cccce93d71e55e1141a163703f54a4b29cc107c23b48b
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb" \
    BITNAMI_IMAGE_VERSION="10.1.41-ol-7-r109" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
