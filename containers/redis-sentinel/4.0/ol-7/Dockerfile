FROM bitnami/oraclelinux-extras:7-r155
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc
RUN bitnami-pkg unpack redis-sentinel-4.0.11-3 --checksum 20ff8cfb708f15e0e001ef8ee55f9e1f661f692e2e321847cfc0c9482766e314

COPY rootfs /
ENV BITNAMI_APP_NAME="redis-sentinel" \
    BITNAMI_IMAGE_VERSION="4.0.11-ol-7-r78" \
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
