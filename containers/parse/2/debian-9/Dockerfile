FROM bitnami/minideb-extras:stretch-r82
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libncurses5 libpcap0.8 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.11.3-0 --checksum d312d68b2b8f85b96d8322187e1c6cb235f64717173ec775b2b02c4cb43c436c
RUN bitnami-pkg install mongodb-client-3.7.9-0 --checksum 8886d69851b2ae39765fe13c89589bfe2375e89296d6ef50c466a127bce82019
RUN bitnami-pkg unpack parse-2.8.2-0 --checksum 6607e7a165d59dd2fe8622c3efc29ebbdd7a8f9d6aa89497120778372edafeab

COPY rootfs /
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="2.8.2-debian-9-r10" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_USER="" \
    PARSE_APP_ID="myappID" \
    PARSE_HOST="127.0.0.1" \
    PARSE_MASTER_KEY="mymasterKey" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_PORT_NUMBER_NUMBER="1337" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:$PATH"

EXPOSE 1337

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","parse"]
