FROM bitnami/minideb-extras:stretch-r493
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.16.2-0 --checksum c7da50178b78b154a323574abec57799aef9d6f8264ddb145d3732a17fd6c4ad
RUN bitnami-pkg unpack parse-dashboard-2.0.3-1 --checksum a94df2c159b3d0444af9147fd64da70f0eff812dc72bac458b08b56e09f2e214

COPY rootfs /
ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="2.0.3-debian-9-r28" \
    NAMI_PREFIX="/.nami" \
    PARSE_APP_ID="myappID" \
    PARSE_DASHBOARD_APP_NAME="MyDashboard" \
    PARSE_DASHBOARD_PASSWORD="bitnami" \
    PARSE_DASHBOARD_USER="user" \
    PARSE_HOST="parse" \
    PARSE_MASTER_KEY="mymasterKey" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_PORT_NUMBER="1337" \
    PARSE_USE_HOSTNAME="no" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/parse-dashboard/bin:$PATH"

EXPOSE 4040

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
