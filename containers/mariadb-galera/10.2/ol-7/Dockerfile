FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages audit-libs ca-certificates curl glibc gzip hostname iproute keyutils-libs krb5-libs libaio libaio-devel libcap-ng libcom_err libgcc libselinux libstdc++ lsof ncurses-libs nss-pam-ldapd nss-softokn-freebl openldap-clients openssl-libs pam pcre procps-ng rsync socat sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "mariadb-galera" "10.2.31-1" --checksum 5e6e9aaeff3fb44fa4bfeddd3cb14822a3b32ebc6362665402988e75e1f0a0a0
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.2.31-ol-7-r7" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
