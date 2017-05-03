FROM bitnami/minideb-extras:jessie-r14
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="3.2.8-r3" \
    PATH="/opt/bitnami/redis/bin:$PATH" \
    REDIS_MASTER_HOST="" \
    REDIS_MASTER_PASSWORD="" \
    REDIS_MASTER_PORT="6379" \
    REDIS_PASSWORD="" \
    REDIS_REPLICATION_MODE=""

# Install required system packages and dependencies
RUN install_packages libc6
RUN bitnami-pkg unpack redis-3.2.8-0 --checksum 2dcd69c0bbcb6e2ab82975d39ee32c2795c612e85012d599d36553c4f5ab8f3d

COPY rootfs /

VOLUME ["/bitnami/redis"]

EXPOSE 6379

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
