FROM gcr.io/stacksmith-images/ubuntu:14.04-r9
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.7-r3 \
    BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongo

RUN bitnami-pkg unpack mongodb-3.2.7-3 --checksum f599dbc1adf9b949834fe121ed356ecbe1fea4dec695b46b6bc618fd28acb79e
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mongodb"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 27017
