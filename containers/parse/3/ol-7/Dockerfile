FROM bitnami/oraclelinux-extras:7-r415
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install node-8.16.0-1 --checksum 470d8ce306757810be4888ed14c57c62b5864eac815fcd86d1e10dc32b52d542
RUN bitnami-pkg install mongodb-client-4.0.11-0 --checksum b0b851e569cef1c36bc95264ff27f89be3ffd6ea55c8318bd7f6e1f67cf5ce7a
RUN bitnami-pkg unpack parse-3.7.2-0 --checksum 66b39f2379cad86924981b7c144410c385b0ec4ba9b7d989873e343fd56d1dae

COPY rootfs /
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="3.7.2-ol-7-r2" \
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
    PARSE_PORT_NUMBER="1337" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:$PATH"

EXPOSE 1337

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
