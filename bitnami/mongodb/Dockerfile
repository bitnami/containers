FROM gcr.io/stacksmith-images/minideb:jessie-r2
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.10-r1 \
    BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongo

# Install mongodb
RUN bitnami-pkg unpack mongodb-3.2.10-0 --checksum 002f9adfc7c005a368eedede50ed94066987068dfddd001997e31a88488ca2e5
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mongodb"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 27017
