FROM bitnami/oraclelinux-extras:7-r51
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc
RUN bitnami-pkg unpack redis-sentinel-4.0.10-0 --checksum 6a257b95dcfb35076b8f99953cf51b5f51446de045953235cb58bd921c40ebb6

COPY rootfs /
ENV BITNAMI_APP_NAME="redis-sentinel" \
    BITNAMI_IMAGE_VERSION="4.0.10-ol-7-r28" \
    PATH="/opt/bitnami/redis-sentinel/bin:$PATH" \
    REDIS_MASTER_HOST="redis" \
    REDIS_MASTER_PASSWORD="" \
    REDIS_MASTER_PORT_NUMBER="6379" \
    REDIS_MASTER_SET="mymaster" \
    REDIS_SENTINEL_PORT_NUMBER="26379" \
    REDIS_SENTINEL_QUORUM="2"

EXPOSE 26379

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","redis-sentinel"]
