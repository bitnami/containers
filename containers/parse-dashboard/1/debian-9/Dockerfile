FROM bitnami/minideb-extras:stretch-r206
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.13.0-2 --checksum 710ba15c17dbe274b91d02310b5ab0abb12b0fe7cde8b703c304c60a3753cd85
RUN bitnami-pkg unpack parse-dashboard-1.2.0-4 --checksum 076df4febb9e93bb67c59d3b298d33d5acf1c0bd6716f77bb23b75450abc2731

COPY rootfs /
ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="1.2.0-debian-9-r58" \
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

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "parse-dashboard" ]
