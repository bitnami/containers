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
RUN . ./libcomponent.sh && component_unpack "mariadb" "10.2.31-0" --checksum 2cb33b2762c5e6fcc4ee8b303ddd575c7a202ca4a28ee6fff259f1489f28ba56
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb" \
    BITNAMI_IMAGE_VERSION="10.2.31-ol-7-r3" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
