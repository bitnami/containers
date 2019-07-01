FROM bitnami/oraclelinux-extras-base:7-r334
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libpcap libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "mongodb" "4.0.10-3" --checksum b421e77c82317e8f0993762c09313ed28338462b2b3a7a6349991e37bbbe0f76

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mongodb" \
    BITNAMI_IMAGE_VERSION="4.0.10-ol-7-r39" \
    MONGODB_ADVERTISED_HOSTNAME="" \
    MONGODB_DATABASE="" \
    MONGODB_DISABLE_SYSTEM_LOG="no" \
    MONGODB_ENABLE_DIRECTORY_PER_DB="no" \
    MONGODB_ENABLE_IPV6="yes" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_PRIMARY_HOST="" \
    MONGODB_PRIMARY_PORT_NUMBER="27017" \
    MONGODB_PRIMARY_ROOT_PASSWORD="" \
    MONGODB_PRIMARY_ROOT_USER="root" \
    MONGODB_REPLICA_SET_KEY="" \
    MONGODB_REPLICA_SET_MODE="" \
    MONGODB_REPLICA_SET_NAME="replicaset" \
    MONGODB_ROOT_PASSWORD="" \
    MONGODB_SYSTEM_LOG_VERBOSITY="0" \
    MONGODB_USERNAME="" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
