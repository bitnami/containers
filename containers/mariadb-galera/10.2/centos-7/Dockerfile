FROM bitnami/centos-extras-base:7-r229
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages audit-libs glibc iproute keyutils-libs krb5-libs libaio libcap-ng libcom_err libgcc libselinux libstdc++ lsof ncurses-libs nss-pam-ldapd nss-softokn-freebl openldap-clients openssl-libs pam pcre rsync socat zlib
RUN . ./libcomponent.sh && component_unpack "mariadb-galera" "10.2.29-1" --checksum 413ab923daa8fad7d95ff54ca293788f3ae67543649f072ebca09fa327a69c78
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.2.29-centos-7-r31" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
