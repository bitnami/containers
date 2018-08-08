FROM bitnami/minideb-extras:stretch-r100
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6
RUN bitnami-pkg unpack redis-sentinel-4.0.11-0 --checksum c66c657466fc100b6ccf640e82040556df70486fd83a372229207abb238ad955

COPY rootfs /
ENV BITNAMI_APP_NAME="redis-sentinel" \
    BITNAMI_IMAGE_VERSION="4.0.11-debian-9-r1" \
    PATH="/opt/bitnami/redis-sentinel/bin:$PATH" \
    REDIS_MASTER_HOST="redis" \
    REDIS_MASTER_PASSWORD="" \
    REDIS_MASTER_PORT_NUMBER="6379" \
    REDIS_MASTER_SET="mymaster" \
    REDIS_SENTINEL_PORT_NUMBER="26379" \
    REDIS_SENTINEL_QUORUM="2"

EXPOSE 26379

USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","redis-sentinel"]
