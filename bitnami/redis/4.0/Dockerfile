FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN bitnami-pkg unpack redis-4.0.6-0 --checksum e9b32631e646b005458989f9066c746d42cf9148bb31263a609444a86f392184

COPY rootfs /

ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="4.0.6-r0" \
    PATH="/opt/bitnami/redis/bin:$PATH" \
    REDIS_MASTER_HOST="" \
    REDIS_MASTER_PASSWORD="" \
    REDIS_MASTER_PORT_NUMBER="6379" \
    REDIS_PASSWORD="" \
    REDIS_REPLICATION_MODE=""

EXPOSE 6379

USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
