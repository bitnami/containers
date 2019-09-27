FROM bitnami/oraclelinux-extras:7-r479
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install node-8.16.1-1 --checksum 5391c115a0a3975b54e41ddbb1dd766e3e62b25a7bdcf1472dacd90236fb794f
RUN bitnami-pkg unpack parse-dashboard-2.0.3-1 --checksum 04b9a089dea6dd2518b8661ab3ffc38084cd098567b131e5b2e6370e8184a2d5

COPY rootfs /
ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="2.0.3-ol-7-r10" \
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
