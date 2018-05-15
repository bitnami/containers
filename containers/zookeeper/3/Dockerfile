FROM bitnami/minideb-extras:jessie-r46
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN bitnami-pkg install java-1.8.171-1 --checksum e8a1956085b60e632976f9671899919b245b6c4dfd0035292b4b47a16669d0fd
RUN bitnami-pkg unpack zookeeper-3.4.12-1 --checksum d7464adb59e4c72c78d129f2c4399cd9aa6b9f09595adc3633044802433a8681

COPY rootfs /
ENV ALLOW_ANONYMOUS_LOGIN="no" \
    BITNAMI_APP_NAME="zookeeper" \
    BITNAMI_IMAGE_VERSION="3.4.12-r1" \
    JVMFLAGS="" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/zookeeper/bin:$PATH" \
    ZOO_CLIENT_PASSWORD="" \
    ZOO_CLIENT_USER="" \
    ZOO_ENABLE_AUTH="no" \
    ZOO_HEAP_SIZE="1024" \
    ZOO_INIT_LIMIT="10" \
    ZOO_PORT_NUMBER="2181" \
    ZOO_SERVERS="" \
    ZOO_SERVER_ID="1" \
    ZOO_SERVER_PASSWORDS="" \
    ZOO_SERVER_USERS="" \
    ZOO_SYNC_LIMIT="5" \
    ZOO_TICK_TIME="2000"

EXPOSE 2181 2888 3888

USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
