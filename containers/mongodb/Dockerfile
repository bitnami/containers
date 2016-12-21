FROM gcr.io/stacksmith-images/minideb:jessie-r7
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.4.1-r0 \
    BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongo

# System packages required
RUN install_packages libssl1.0.0 libc6 libgcc1 libpcap0.8

# Install mongodb
RUN bitnami-pkg unpack mongodb-3.4.1-0 --checksum c4aaa270244d73289f6229ad93980cc724a03cb7035fa198e5d4d1cc35a8f092

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mongodb"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 27017
