FROM gcr.io/stacksmith-images/minideb:jessie-r11

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=parse \
    BITNAMI_IMAGE_VERSION=2.3.7-r0 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:$PATH

# System packages required
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

# Additional modules required
RUN bitnami-pkg install node-4.8.0-0 --checksum 800e972fbdf1b0a5afc845990bb981359dee4f9ad31ae4115a18ababa6c66508
RUN bitnami-pkg install mongodb-client-3.4.2-1 --checksum 7ab29c774c254b155fdb0ea02ed244d8acd93964edab384df7fce3fd8e544673

# Install parse
RUN bitnami-pkg unpack parse-2.3.7-0 --checksum 2b4a548e27faa10784f15e87e475b707c39f5d51bf913c9bd29740764a8236a6

COPY rootfs /

ENV PARSE_PORT="1337" \
    PARSE_HOST="127.0.0.1" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_APP_ID="myappID" \
    PARSE_MASTER_KEY="mymasterKey" \
    MONGODB_HOST="mongodb" \
    MONGODB_PORT="27017"

VOLUME ["/bitnami/parse"]

EXPOSE 1337

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "parse"]
