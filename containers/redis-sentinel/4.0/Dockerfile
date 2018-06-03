FROM bitnami/minideb-extras:jessie-r66
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg unpack redis-sentinel-4.0.9-1 --checksum 98c2482692bd81e50137d4dec6bb410a4af07098639c375411608161db269282

COPY rootfs /
ENV BITNAMI_APP_NAME="redis-sentinel" \
    BITNAMI_IMAGE_VERSION="4.0.9-r5" \
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
