FROM gcr.io/stacksmith-images/ubuntu:14.04-r9
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.10.1-r1 \
    BITNAMI_APP_NAME=nginx \
    BITNAMI_APP_USER=daemon

RUN bitnami-pkg unpack nginx-1.10.1-0 --checksum f3741261924f9076d4de8fdd5017cd5ee81fa80c3c4d20cef8ba89ae7f8a5cb8
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/html /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "nginx"]

WORKDIR /app

EXPOSE 80 443
