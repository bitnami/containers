FROM bitnami/oraclelinux-extras:7-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libgcc libpcap libselinux openssl-libs pcre zlib
RUN bitnami-pkg unpack mongodb-3.6.5-2 --checksum aa0f8b11f6a3fac8fccce9fd46bc2de48275f0ad8c32df95072c2b02cd7cbce6

COPY rootfs /
ENV BITNAMI_APP_NAME="mongodb" \
    BITNAMI_IMAGE_VERSION="3.6.5-ol-7-r8" \
    MONGODB_ADVERTISED_HOSTNAME="" \
    MONGODB_DATABASE="" \
    MONGODB_PASSWORD="" \
    MONGODB_PRIMARY_HOST="" \
    MONGODB_PRIMARY_PORT_NUMBER="27017" \
    MONGODB_PRIMARY_ROOT_PASSWORD="" \
    MONGODB_PRIMARY_ROOT_USER="root" \
    MONGODB_REPLICA_SET_KEY="" \
    MONGODB_REPLICA_SET_MODE="" \
    MONGODB_REPLICA_SET_NAME="replicaset" \
    MONGODB_ROOT_PASSWORD="" \
    MONGODB_USERNAME="" \
    PATH="/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
