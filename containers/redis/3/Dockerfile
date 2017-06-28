FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6
RUN bitnami-pkg unpack redis-3.2.9-1 --checksum 1f59bcfdd9590e7aa2b46aa140dd7a7f1816edbf0351f8877c313d951f835aa5

COPY rootfs /

ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="3.2.9-r3" \
    PATH="/opt/bitnami/redis/bin:$PATH" \
    REDIS_MASTER_HOST="" \
    REDIS_MASTER_PASSWORD="" \
    REDIS_MASTER_PORT_NUMBER="6379" \
    REDIS_PASSWORD="" \
    REDIS_REPLICATION_MODE=""




EXPOSE 6379

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
