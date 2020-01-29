FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages audit-libs ca-certificates curl glibc gzip hostname iproute keyutils-libs krb5-libs libaio libaio-devel libcap-ng libcom_err libgcc libselinux libstdc++ lsof ncurses-libs nss-pam-ldapd nss-softokn-freebl openldap-clients openssl-libs pam pcre procps-ng rsync socat sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "mariadb-galera" "10.2.31-0" --checksum 06141b7be38441f650efb52277684f2f413b7f3434b7010eb8bf2adfd6bdd8e8
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.2.31-ol-7-r0" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
