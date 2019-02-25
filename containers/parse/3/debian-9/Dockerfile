FROM bitnami/minideb-extras:stretch-r295
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.15.0-0 --checksum ba314e8ce24c285b7096c0549a809de505f24935b61e3f52bf121b16d88a7123
RUN bitnami-pkg install mongodb-client-4.0.6-0 --checksum 4ea3b98e3e4d24ffb070810af11294b01b06d5aecf7376cd28d843e8b75ed846
RUN bitnami-pkg unpack parse-3.1.3-1 --checksum 7fc45dbad32785295be7f7a686798d4388f08258b6be8199186885d58462d8ca

COPY rootfs /
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="3.1.3-debian-9-r44" \
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
