FROM bitnami/minideb-extras-base:stretch-r29
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "redis" "4.0.11-4" --checksum 039d9867ca9b4f7adce950989b66b9b59e5d542ff8d102248a4ab04b47fbe3f5

COPY rootfs /
RUN /prepare.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="4.0.11-debian-9-r45" \
    PATH="/opt/bitnami/redis/bin:$PATH" \
    REDIS_DISABLE_COMMANDS="" \
    REDIS_MASTER_HOST="" \
    REDIS_MASTER_PASSWORD="" \
    REDIS_MASTER_PORT_NUMBER="6379" \
    REDIS_PASSWORD="" \
    REDIS_REPLICATION_MODE=""

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
