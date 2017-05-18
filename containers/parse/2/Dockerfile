FROM bitnami/minideb-extras:jessie-r15
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libpcap0.8 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-4.8.3-0 --checksum 82ac604d6b97bd2070c8ff613de802096e5addd644d6817745ca2aa71d689aa3
RUN bitnami-pkg install mongodb-client-3.4.4-0 --checksum fc5f6aa0882a5bef86a45493efd04dbaf3947777bc955f7f9a0b035b77d18c94
RUN bitnami-pkg unpack parse-2.3.8-0 --checksum 02d027d039ea6e1ede5c38ce93154dcd93f634b4567d2126e03a819e37ae1782

COPY rootfs /

ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="2.3.8-r2" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT="27017" \
    MONGODB_USER="" \
    PARSE_APP_ID="myappID" \
    PARSE_HOST="127.0.0.1" \
    PARSE_MASTER_KEY="mymasterKey" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_PORT="1337" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:$PATH"

VOLUME ["/bitnami/parse"]

EXPOSE 1337

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","parse"]
