FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=parse \
    BITNAMI_IMAGE_VERSION=2.3.8-r0 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:$PATH

# System packages required
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

# Additional modules required
RUN bitnami-pkg install node-4.8.2-0 --checksum 3e5b6898fee0ef9ef59ebecd4eb23fb1b2cc99215d4fdfd49c8c3e6b49bd86e3
RUN bitnami-pkg install mongodb-client-3.4.3-0 --checksum 93649ee8a28735850e3354c9048a2affff527c3f5dd3a80d0dd0f5bd043f4ef3

# Install parse
RUN bitnami-pkg unpack parse-2.3.8-0 --checksum 02d027d039ea6e1ede5c38ce93154dcd93f634b4567d2126e03a819e37ae1782

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
