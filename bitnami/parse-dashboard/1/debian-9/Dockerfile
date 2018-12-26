FROM bitnami/minideb-extras:stretch-r234
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.14.1-0 --checksum 3ad59ddee88c0f80a8508775b73997507063007395b300cd066d54ecfead2a48
RUN bitnami-pkg unpack parse-dashboard-1.2.0-20 --checksum be2350ac9e70a56e92cf2f0f945f0297484e652540498bdcfa782ef7fc32b43d

COPY rootfs /
ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="1.2.0-debian-9-r75" \
    NAMI_PREFIX="/.nami" \
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

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
