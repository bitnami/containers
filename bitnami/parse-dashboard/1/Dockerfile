FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-4.8.3-0 --checksum 82ac604d6b97bd2070c8ff613de802096e5addd644d6817745ca2aa71d689aa3
RUN bitnami-pkg unpack parse-dashboard-1.1.0-0 --checksum a1b9847ff4776a5ac69715ed6a6ab8e022e02343028501e76d9fe278595946f3

COPY rootfs /

ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="1.1.0-r0" \
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
