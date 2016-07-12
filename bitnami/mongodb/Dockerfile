FROM gcr.io/stacksmith-images/ubuntu:14.04-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.7-r1 \
    BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongo

RUN bitnami-pkg unpack mongodb-3.2.7-1 --checksum 98d972ec5f6a34b3fc7a82e76600d9ac6c209537d93402e3b29de9e066440b14
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "mongodb"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 27017
