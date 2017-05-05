FROM bitnami/minideb-extras:jessie-r15

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=parse-dashboard \
    BITNAMI_IMAGE_VERSION=1.0.25-r1 \
    PATH=/opt/bitnami/node/bin:$PATH

# System packages required
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 libsqlite3-0 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

# Additional modules required
RUN bitnami-pkg install node-4.8.3-0 --checksum 82ac604d6b97bd2070c8ff613de802096e5addd644d6817745ca2aa71d689aa3

# Install parsedashboard
RUN bitnami-pkg unpack parse-dashboard-1.0.25-0 --checksum 8986a5cd44179085e40118130b0ab117e0a281c07a48e46d3deb30ffad1c7eeb

COPY rootfs /

ENV PARSE_HOST="parse" \
    PARSE_PORT="1337" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_MASTER_KEY="mymasterKey" \
    PARSE_APP_ID="myappID" \
    PARSE_DASHBOARD_APP_NAME="MyDashboard" \
    PARSE_DASHBOARD_USER="user" \
    PARSE_DASHBOARD_PASSWORD="bitnami"

VOLUME ["/bitnami/parse-dashboard"]

EXPOSE 4040

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "parse-dashboard"]
