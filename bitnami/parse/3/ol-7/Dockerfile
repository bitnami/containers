FROM bitnami/oraclelinux-extras:7-r519
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install node-8.16.2-1 --checksum 6b7a334fb0fd72a30332ad0132695503752d0564ab7f3a0c2fd0a7513d30d1bf
RUN bitnami-pkg install mongodb-client-4.0.13-0 --checksum e0d6f27b173e6c09071a3b3416be0d79f606f2472ed8864db770d025040cf22a
RUN bitnami-pkg unpack parse-3.9.0-1 --checksum 5ec298655b3ea49e1e50d58532cb57449ae4803adafce025ea3997e303218c29

COPY rootfs /
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="3.9.0-ol-7-r57" \
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
