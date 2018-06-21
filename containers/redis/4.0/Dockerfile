FROM bitnami/minideb-extras:jessie-r83
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN bitnami-pkg unpack redis-4.0.10-0 --checksum 4168e47eb043c99e9ed9932c97f0a5973828811d77c2c05c9e2e434bbd39ae40

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="4.0.10-r9" \
    PATH="/opt/bitnami/redis/bin:$PATH" \
    REDIS_DISABLE_COMMANDS="" \
    REDIS_MASTER_HOST="" \
    REDIS_MASTER_PASSWORD="" \
    REDIS_MASTER_PORT_NUMBER="6379" \
    REDIS_PASSWORD="" \
    REDIS_REPLICATION_MODE=""

EXPOSE 6379

USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
