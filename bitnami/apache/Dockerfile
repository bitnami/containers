FROM gcr.io/stacksmith-images/ubuntu:14.04-r9
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=2.4.23-r5 \
    BITNAMI_APP_NAME=apache \
    BITNAMI_APP_USER=daemon

RUN bitnami-pkg unpack apache-2.4.23-4 --checksum 031ccfca981a152b4daadf3b78843e24c01136c0db458f6fd816fc8428c76bbe
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/htdocs /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "apache"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

WORKDIR /app

EXPOSE 80 443
