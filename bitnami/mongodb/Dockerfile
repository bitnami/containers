FROM gcr.io/stacksmith-images/minideb:jessie-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.4.2-r0 \
    BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongo

# System packages required
RUN install_packages libssl1.0.0 libc6 libgcc1 libpcap0.8

# Install mongodb
RUN bitnami-pkg unpack mongodb-3.4.2-0 --checksum 0a8221d11312a3dc909010b0c4aa171adc2dd3b3d0ed50b240f629c3deb127c9

ENV PATH=/opt/bitnami/mongodb/sbin:/opt/bitnami/mongodb/bin:$PATH

COPY rootfs/ /

ENV MONGODB_ROOT_PASSWORD= \
    MONGODB_USERNAME= \
    MONGODB_PASSWORD= \
    MONGODB_DATABASE= \
    MONGODB_REPLICA_SET_MODE= \
    MONGODB_REPLICA_SET_NAME= \
    MONGODB_REPLICA_SET_KEY= \
    MONGODB_PRIMARY_HOST= \
    MONGODB_PRIMARY_PORT=27017 \
    MONGODB_PRIMARY_ROOT_USER=root \
    MONGODB_PRIMARY_ROOT_PASSWORD=

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "mongodb"]

VOLUME ["/bitnami/mongodb"]

EXPOSE 27017
