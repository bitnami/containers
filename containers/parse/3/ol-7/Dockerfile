FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl cyrus-sasl-lib glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre procps-ng readline sqlite sudo tar which zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install node-8.17.0-0 --checksum c6720534f7fa5167debe21fb272168c98ef912b1b8c57eb50a21669b6ca16192
RUN bitnami-pkg install mongodb-client-4.2.3-0 --checksum cdc8ed76ef2b9df4c9fac30c2b86d65b3a7c9af6e2a8a55f0c1063af3044a02a
RUN bitnami-pkg unpack parse-3.10.0-0 --checksum ad1521691c650449ffe73e044d24b5f5ecaf066212e7a98873ef393f8b64b90b
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="3.10.0-ol-7-r17" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_USER="root" \
    NAMI_PREFIX="/.nami" \
    PARSE_APP_ID="myappID" \
    PARSE_ENABLE_CLOUD_CODE="no" \
    PARSE_HOST="127.0.0.1" \
    PARSE_MASTER_KEY="mymasterKey" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_PORT_NUMBER="1337"

EXPOSE 1337

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
