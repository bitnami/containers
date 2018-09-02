FROM bitnami/oraclelinux-extras:7-r92
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install node-8.11.4-0 --checksum af7a50f918af19b1e8d530394c151101bb10281877f100f391b50cdcebdb7455
RUN bitnami-pkg unpack parse-dashboard-1.2.0-2 --checksum f2bee5ee6b3be72a5b15d5e7ce4679f82e2d786c3045fb754e07818cf10d73d3

COPY rootfs /
ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="1.2.0-ol-7-r28" \
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
