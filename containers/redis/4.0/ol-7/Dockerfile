FROM bitnami/oraclelinux-extras:7-r26
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc
RUN bitnami-pkg unpack redis-4.0.10-1 --checksum abab4c3d5dd728e0b0e9c7b34979abd5ea11f0395924dcef3c9dc4848d6f191f

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="4.0.10-ol-7-r15" \
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
