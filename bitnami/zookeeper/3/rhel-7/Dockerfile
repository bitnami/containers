FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc
RUN bitnami-pkg install java-1.8.201-0 --checksum 9216aff7a05a39c45934859a19b66a5e1f343449fd929544a3aff1a6cddb35c2
RUN bitnami-pkg unpack zookeeper-3.4.13-1 --checksum 15ab60ab17ced24bfd5f68a91e20e47eb8b4f0aa8d9b72218d33da6e47c98349

COPY rootfs /
ENV ALLOW_ANONYMOUS_LOGIN="no" \
    BITNAMI_APP_NAME="zookeeper" \
    BITNAMI_IMAGE_VERSION="3.4.13-rhel-7-r10" \
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
