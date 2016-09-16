FROM gcr.io/stacksmith-images/ubuntu:14.04-r9
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=2.4.23-r4 \
    BITNAMI_APP_NAME=apache \
    BITNAMI_APP_USER=daemon

RUN bitnami-pkg unpack apache-2.4.23-3 --checksum b75ced97d6b6f9dd8d0114ee0ca3943250af6edc91a20857f68165e4bf7d35fa
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/htdocs /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "apache"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

WORKDIR /app

EXPOSE 80 443
