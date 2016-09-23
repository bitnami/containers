FROM gcr.io/stacksmith-images/ubuntu:14.04-r10
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.3-r0 \
    BITNAMI_APP_NAME=redis \
    BITNAMI_APP_USER=redis

# Install redis
RUN bitnami-pkg unpack redis-3.2.3-0 --checksum 0d30ae8917baddc32ea50e10021e736532b92e5320781b710676daf94e00ec87
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "redis"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 6379
