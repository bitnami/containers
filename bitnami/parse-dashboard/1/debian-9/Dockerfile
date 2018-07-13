FROM bitnami/minideb-extras:stretch-r76
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.11.3-0 --checksum d312d68b2b8f85b96d8322187e1c6cb235f64717173ec775b2b02c4cb43c436c
RUN bitnami-pkg unpack parse-dashboard-1.2.0-1 --checksum 7517b0dc1ac6f385660c1967dee65c23fe3bbd23befd4b0bb6fa762ff7feb9c0

COPY rootfs /
ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="1.2.0-debian-9-r4" \
    PARSE_APP_ID="myappID" \
    PARSE_DASHBOARD_APP_NAME="MyDashboard" \
    PARSE_DASHBOARD_PASSWORD="bitnami" \
    PARSE_DASHBOARD_USER="user" \
    PARSE_HOST="parse" \
    PARSE_MASTER_KEY="mymasterKey" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_PORT_NUMBER="1337" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/parse-dashboard/bin:$PATH"

EXPOSE 4040

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","parse-dashboard"]
