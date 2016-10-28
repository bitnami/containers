FROM gcr.io/stacksmith-images/minideb:jessie-r2
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.5-r0 \
    BITNAMI_APP_NAME=redis \
    BITNAMI_APP_USER=redis

# Install redis
RUN bitnami-pkg unpack redis-3.2.5-0 --checksum fd1f0df0d8cfc9d2b21b91b557b0b108562714c085ad481407d82aabfa43957b
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "redis"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 6379
