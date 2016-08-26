FROM gcr.io/stacksmith-images/ubuntu:14.04-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.7-r3 \
    BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongo

RUN bitnami-pkg unpack mongodb-3.2.7-3 --checksum fcf80d5057a5895821a8776bf2a8168db2ba13c764b56bdde367799dedec10b6
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "mongodb"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 27017
