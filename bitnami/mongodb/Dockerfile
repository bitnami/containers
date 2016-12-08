FROM gcr.io/stacksmith-images/minideb:jessie-r5
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.11-r1 \
    BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongo

# System packages required
RUN install_packages libc6 libgcc1

# Install mongodb
RUN bitnami-pkg unpack mongodb-3.2.11-1 --checksum c3d7fe942ee8cc46aa222b1e63053d9936d33e1dac2d791ad0fad3616c543329

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mongodb"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 27017
