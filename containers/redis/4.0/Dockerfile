FROM bitnami/minideb-extras:jessie-r20
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6
RUN bitnami-pkg unpack redis-4.0.1-0 --checksum 1f1aeb4208b204e299a9ce1c845cfcfb6e24eb0b41726888bcc2432145f88448

COPY rootfs /

ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="4.0.1-r0" \
    PATH="/opt/bitnami/redis/bin:$PATH" \
    REDIS_MASTER_HOST="" \
    REDIS_MASTER_PASSWORD="" \
    REDIS_MASTER_PORT_NUMBER="6379" \
    REDIS_PASSWORD="" \
    REDIS_REPLICATION_MODE=""

EXPOSE 6379

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
