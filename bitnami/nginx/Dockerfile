FROM gcr.io/stacksmith-images/minideb:jessie-r0
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.10.2-r0 \
    BITNAMI_APP_NAME=nginx \
    BITNAMI_APP_USER=daemon

RUN bitnami-pkg unpack nginx-1.10.2-0 --checksum 65c0fb94839fc624a078b89424f992d9da46912c59f39a54161484354133ec37
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/html /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "nginx"]

WORKDIR /app

EXPOSE 80 443
