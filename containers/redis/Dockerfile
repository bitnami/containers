FROM gcr.io/stacksmith-images/ubuntu:14.04-r10
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.4-r0 \
    BITNAMI_APP_NAME=redis \
    BITNAMI_APP_USER=redis

# Install redis
RUN bitnami-pkg unpack redis-3.2.4-0 --checksum 00fea780e99fbd91b9a518ec1509688161fb9f57be7afc0d6e3175640c2e0aa5
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "redis"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 6379
