FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages audit-libs ca-certificates curl glibc gzip hostname keyutils-libs krb5-libs libaio libaio-devel libcap-ng libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pam pcre procps-ng sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "mariadb" "10.1.43-0" --checksum bf7c9369f33415b4f70992d32df3b3916f0836204dffe4c009b045c3a63f4ebc
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb" \
    BITNAMI_IMAGE_VERSION="10.1.43-ol-7-r80" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
