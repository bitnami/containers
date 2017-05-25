FROM bitnami/minideb-extras:jessie-r15
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-4.8.3-0 --checksum 82ac604d6b97bd2070c8ff613de802096e5addd644d6817745ca2aa71d689aa3
RUN bitnami-pkg unpack parse-dashboard-1.0.26-0 --checksum 7fce879a5d46d64103a748f6806d491494e24a346d47c98c8b4f0156c7a3b88d

COPY rootfs /

ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="1.0.26-r1" \
    PARSE_APP_ID="myappID" \
    PARSE_DASHBOARD_APP_NAME="MyDashboard" \
    PARSE_DASHBOARD_PASSWORD="bitnami" \
    PARSE_DASHBOARD_USER="user" \
    PARSE_HOST="parse" \
    PARSE_MASTER_KEY="mymasterKey" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_PORT_NUMBER="1337" \
    PATH="/opt/bitnami/node/bin:$PATH"



VOLUME ["/bitnami/parse-dashboard"]

EXPOSE 4040

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","parse-dashboard"]
