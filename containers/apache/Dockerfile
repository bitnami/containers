FROM gcr.io/stacksmith-images/ubuntu:14.04-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=2.4.23-r0 \
    BITNAMI_APP_NAME=apache \
    BITNAMI_APP_USER=daemon

RUN bitnami-pkg unpack apache-2.4.23-0 --checksum 90b395bdb707cdbfc7786d79c4c064cade1135f94ff7f973d359c28c5ee8cebf
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/htdocs /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "apache"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

WORKDIR /app

EXPOSE 80 443
