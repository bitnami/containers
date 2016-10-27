FROM gcr.io/stacksmith-images/ubuntu:14.04-r10
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=2.4.23-r7 \
    BITNAMI_APP_NAME=apache \
    BITNAMI_APP_USER=daemon

RUN bitnami-pkg unpack apache-2.4.23-8 --checksum 391deed983f7aaa04b4b47af59d8e8ced4f88076eff18d5405d196b6b270433c
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/htdocs /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "apache"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

WORKDIR /app

EXPOSE 80 443
