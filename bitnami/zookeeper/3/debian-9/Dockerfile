FROM bitnami/minideb-extras:stretch-r234
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1
RUN bitnami-pkg install java-1.8.191-21 --checksum de7e78f5dbce5a3c2343e2a40f2f335868bd547598f1df364247b4425f2f2f1a
RUN bitnami-pkg unpack zookeeper-3.4.12-21 --checksum e57b3a03cde3762ce6c4e047a3ca07fc4fff66b01e0b27c4a636c969a812e83b

COPY rootfs /
ENV ALLOW_ANONYMOUS_LOGIN="no" \
    BITNAMI_APP_NAME="zookeeper" \
    BITNAMI_IMAGE_VERSION="3.4.12-debian-9-r142" \
    JVMFLAGS="" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/zookeeper/bin:$PATH" \
    ZOO_CLIENT_PASSWORD="" \
    ZOO_CLIENT_USER="" \
    ZOO_ENABLE_AUTH="no" \
    ZOO_HEAP_SIZE="1024" \
    ZOO_INIT_LIMIT="10" \
    ZOO_MAX_CLIENT_CNXNS="60" \
    ZOO_PORT_NUMBER="2181" \
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
