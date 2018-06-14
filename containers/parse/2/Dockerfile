FROM bitnami/minideb-extras:jessie-r76
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libpcap0.8 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.11.3-0 --checksum e8a276dcff0eb7c501f7c8ba7bd3df532886faf31701fa83c4ab0d7614b4bef2
RUN bitnami-pkg install mongodb-client-3.7.9-0 --checksum c0ef44b2e83dfc7edc9c539b426b990c114311bcd2b7b786959a6a6ece5c50d7
RUN bitnami-pkg unpack parse-2.8.2-0 --checksum a2226696cae84528bd2197998c51ab20f2b5cb6d9cce88c168c80e1d44399ce7

COPY rootfs /
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="2.8.2-r0" \
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
