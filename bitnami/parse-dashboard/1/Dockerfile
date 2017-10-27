FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-4.8.5-0 --checksum e4c1b99ede6d5c86cd94bf449704f0454de44104d3fb71bb3c0040b8cb84f2fe
RUN bitnami-pkg unpack parse-dashboard-1.1.2-0 --checksum d760113e6749bea92d384908ec94c0f8ca470f60e1db08f11fb4344363aa57ba

COPY rootfs /

ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="1.1.2-r0" \
    PARSE_APP_ID="myappID" \
    PARSE_DASHBOARD_APP_NAME="MyDashboard" \
    PARSE_DASHBOARD_PASSWORD="bitnami" \
    PARSE_DASHBOARD_USER="user" \
    PARSE_HOST="parse" \
    PARSE_MASTER_KEY="mymasterKey" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_PORT_NUMBER="1337" \
    PATH="/opt/bitnami/node/bin:$PATH"

EXPOSE 4040

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","parse-dashboard"]
