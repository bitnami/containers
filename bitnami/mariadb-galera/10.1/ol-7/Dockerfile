FROM bitnami/oraclelinux-extras-base:7-r421
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages audit-libs glibc hostname iproute keyutils-libs krb5-libs libaio libcap-ng libcom_err libgcc libselinux libstdc++ lsof ncurses-libs nss-pam-ldapd nss-softokn-freebl openldap-clients openssl-libs pam pcre rsync socat zlib
RUN . ./libcomponent.sh && component_unpack "mariadb-galera" "10.1.41-2" --checksum 523a8d4cf0276228312bcdccd9e2ee9f939718f2c470649e67f72b98e363e67d
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.1.41-ol-7-r53" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
