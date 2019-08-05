FROM bitnami/oraclelinux-extras:7-r418
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc zlib
RUN bitnami-pkg install java-1.8.222-0 --checksum a90f4ce71ff9b392efdf61e6941117afa31d2d6528bd1a3cad1c6459bcac2b0b
RUN bitnami-pkg unpack zookeeper-3.5.5-3 --checksum ff16f181238a5a0edb088f80c95874250acd5ddf9c5c5623cc815abc89aa5353

COPY rootfs /
ENV ALLOW_ANONYMOUS_LOGIN="no" \
    BITNAMI_APP_NAME="zookeeper" \
    BITNAMI_IMAGE_VERSION="3.5.5-ol-7-r64" \
    JVMFLAGS="" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/zookeeper/bin:$PATH" \
    ZOO_CLIENT_PASSWORD="" \
    ZOO_CLIENT_USER="" \
    ZOO_ENABLE_AUTH="no" \
    ZOO_HEAP_SIZE="1024" \
    ZOO_INIT_LIMIT="10" \
    ZOO_LOG_LEVEL="INFO" \
    ZOO_MAX_CLIENT_CNXNS="60" \
    ZOO_PORT_NUMBER="2181" \
    ZOO_RECONFIG_ENABLED="no" \
    ZOO_SERVERS="" \
    ZOO_SERVER_ID="1" \
    ZOO_SERVER_PASSWORDS="" \
    ZOO_SERVER_USERS="" \
    ZOO_SYNC_LIMIT="5" \
    ZOO_TICK_TIME="2000"

EXPOSE 2181 2888 3888

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
