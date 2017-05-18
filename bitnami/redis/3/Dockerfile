FROM bitnami/minideb-extras:jessie-r15
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6
RUN bitnami-pkg unpack redis-3.2.9-0 --checksum 80dea4e656a77683a5cf953b3a7c59c38c68fd5579e865b5a8eb504ccffb9e98

COPY rootfs /

ENV BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="3.2.9-r0" \
    PATH="/opt/bitnami/redis/bin:$PATH" \
    REDIS_MASTER_HOST="" \
    REDIS_MASTER_PASSWORD="" \
    REDIS_MASTER_PORT="6379" \
    REDIS_PASSWORD="" \
    REDIS_REPLICATION_MODE=""

VOLUME ["/bitnami/redis"]

EXPOSE 6379

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
