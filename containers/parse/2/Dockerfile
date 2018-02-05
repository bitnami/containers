FROM bitnami/minideb-extras:jessie-r23
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libpcap0.8 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-6.12.3-0 --checksum 8a396c78801a709598d05bec6de6d617cb65f81c874ac8966dc781aa220a0e91
RUN bitnami-pkg install mongodb-client-3.7.1-0 --checksum defddf01aec3aaa93a31894ffedd2634e086a135189baaa862f8c1757382da64
RUN bitnami-pkg unpack parse-2.7.2-0 --checksum 4997454fd87e52a4e6931a029d83abec0214f617104e4d078ba3b82c66806d23

COPY rootfs /

ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="2.7.2-r0" \
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
