FROM gcr.io/stacksmith-images/ubuntu:14.04-r10
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.10.1-r3 \
    BITNAMI_APP_NAME=nginx \
    BITNAMI_APP_USER=daemon

RUN bitnami-pkg unpack nginx-1.10.1-1 --checksum 2b670035d7ead2c88932ef1a8290afddfd1c149838c4dd629fdd506346c1051b
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/html /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "nginx"]

WORKDIR /app

EXPOSE 80 443
