FROM gcr.io/stacksmith-images/ubuntu:14.04-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.0-r2 \
    BITNAMI_APP_NAME=redis \
    BITNAMI_APP_USER=redis

RUN bitnami-pkg unpack redis-3.2.0-1 --checksum bc4553331a07ffc6ac4cf158b93ee98fb4b4586cb2a16b8a42c85e49f152bb18
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "redis"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 6379
