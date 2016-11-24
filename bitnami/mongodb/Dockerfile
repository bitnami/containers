FROM gcr.io/stacksmith-images/minideb:jessie-r2
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.11-r0 \
    BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongo

# Install mongodb
RUN bitnami-pkg unpack mongodb-3.2.11-0 --checksum 7c95672538244eedf24e88cf335c8b02951717bdcdacb7c98f3feb5f02a6fedb
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mongodb"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 27017
