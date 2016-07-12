FROM gcr.io/stacksmith-images/ubuntu:14.04-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.0-r1 \
    BITNAMI_APP_NAME=redis \
    BITNAMI_APP_USER=redis

RUN bitnami-pkg unpack redis-3.2.0-0 --checksum 4b462cc8ad13553c6aa78249ff344d44f9800ee9909de59599a0de3d66078f20
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "redis"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 6379
