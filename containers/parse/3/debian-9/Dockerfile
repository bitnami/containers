FROM bitnami/minideb-extras:stretch-r131
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libncurses5 libpcap0.8 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.11.4-0 --checksum 53bef241a57487b05ec9de7e18136d6ca3d1b6d54e638d26ad7b71c47c423504
RUN bitnami-pkg install mongodb-client-3.7.9-0 --checksum 8886d69851b2ae39765fe13c89589bfe2375e89296d6ef50c466a127bce82019
RUN bitnami-pkg unpack parse-3.0.0-0 --checksum 39e7f1fe162e56ee5f9ea3d87913242ceab47b392959a8b6c61134cec7e700ad

COPY rootfs /
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="3.0.0-debian-9-r5" \
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
