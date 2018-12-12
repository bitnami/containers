FROM bitnami/oraclelinux-extras:7-r195
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc
RUN bitnami-pkg unpack redis-sentinel-5.0.2-20 --checksum 19be5a3e6f0b6a1824affa56a7bac4a4acd04b5f5f6cd3fa643c6a8d2afc28f0

COPY rootfs /
ENV BITNAMI_APP_NAME="redis-sentinel" \
    BITNAMI_IMAGE_VERSION="5.0.2-ol-7-r20" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/redis-sentinel/bin:$PATH" \
    REDIS_MASTER_HOST="redis" \
    REDIS_MASTER_PASSWORD="" \
    REDIS_MASTER_PORT_NUMBER="6379" \
    REDIS_MASTER_SET="mymaster" \
    REDIS_SENTINEL_PORT_NUMBER="26379" \
    REDIS_SENTINEL_QUORUM="2"

EXPOSE 26379

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "redis-sentinel" ]
