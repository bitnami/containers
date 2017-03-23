FROM bitnami/minideb-extras:jessie-r13
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.8-r2 \
    BITNAMI_APP_NAME=redis \
    PATH=/opt/bitnami/redis/bin:$PATH

# System packages required
RUN install_packages libc6

# Install redis
RUN bitnami-pkg unpack redis-3.2.8-0 --checksum 2dcd69c0bbcb6e2ab82975d39ee32c2795c612e85012d599d36553c4f5ab8f3d

COPY rootfs /

ENV REDIS_PASSWORD= \
    REDIS_REPLICATION_MODE= \
    REDIS_MASTER_HOST= \
    REDIS_MASTER_PORT=6379 \
    REDIS_MASTER_PASSWORD=

VOLUME ["/bitnami/redis"]

EXPOSE 6379

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/run.sh"]
