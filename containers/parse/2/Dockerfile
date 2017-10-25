FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libpcap0.8 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-6.11.5-0 --checksum 689f699e6828854c74a632359d4a2ca7bf59b7d0dd5218a4b20596581a163ac0
RUN bitnami-pkg install mongodb-client-3.4.9-0 --checksum b9fbedef23c4babfc95cab324fa7b93db97c02160431879c271b98a27f36225b
RUN bitnami-pkg unpack parse-2.6.4-0 --checksum 50c0ed389e47568b9a4de5b0ffa165e9e7302a0b6fac51d53405bcad14ec21c5

COPY rootfs /

ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="2.6.4-r0" \
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
