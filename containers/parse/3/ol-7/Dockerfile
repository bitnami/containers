FROM bitnami/oraclelinux-extras:7-r148
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libpcap libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install node-8.12.0-1 --checksum fbc52e3d87bb5121551b78f7d390be34e5ca01c5d0630aea39df0def20ce55b8
RUN bitnami-pkg install mongodb-client-3.7.9-0 --checksum 7fbdfb5064e75d6b1aebb7a25e272649f20ac267347c8e6cd75e4c555c5ba509
RUN bitnami-pkg unpack parse-3.1.0-0 --checksum d36f03a4406117b91cca68ba8918decaac7d77537b8c8ba8a23a812d68e988b6

COPY rootfs /
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="3.1.0-ol-7-r7" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_USER="root" \
    PARSE_APP_ID="myappID" \
    PARSE_HOST="127.0.0.1" \
    PARSE_MASTER_KEY="mymasterKey" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_PORT_NUMBER="1337" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:$PATH"

EXPOSE 1337

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "parse" ]
