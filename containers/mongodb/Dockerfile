FROM gcr.io/stacksmith-images/ubuntu:14.04-r10
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.9-r2 \
    BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongo

# Install mongodb
RUN bitnami-pkg unpack mongodb-3.2.9-2 --checksum 2c00d5f0501fc50a7095de7e70f9fbef9c5f58bcb78e0096e4ed70262959ee2e
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mongodb"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 27017
