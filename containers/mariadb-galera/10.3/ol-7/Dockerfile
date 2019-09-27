FROM bitnami/oraclelinux-extras-base:7-r430
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages audit-libs glibc hostname iproute keyutils-libs krb5-libs libaio libcap-ng libcom_err libgcc libselinux libstdc++ lsof ncurses-libs nss-pam-ldapd nss-softokn-freebl openldap-clients openssl-libs pam pcre rsync socat zlib
RUN . ./libcomponent.sh && component_unpack "mariadb-galera" "10.3.18-2" --checksum a1f16832d6e99c684b5442f46684754a7f2efcdb54212c3c6a0f756a1bb8fa86
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.3.18-ol-7-r19" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
