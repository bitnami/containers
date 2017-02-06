FROM gcr.io/stacksmith-images/minideb:jessie-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.4.2-r0 \
    BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongo

# System packages required
RUN install_packages libssl1.0.0 libc6 libgcc1 libpcap0.8

# Install mongodb
RUN bitnami-pkg unpack mongodb-3.4.2-0 --checksum 0a8221d11312a3dc909010b0c4aa171adc2dd3b3d0ed50b240f629c3deb127c9

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mongodb"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 27017
