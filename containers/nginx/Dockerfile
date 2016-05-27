FROM gcr.io/stacksmith-images/ubuntu:14.04-r07
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.10.0-r0 \
    BITNAMI_APP_NAME=nginx \
    BITNAMI_APP_USER=daemon

RUN bitnami-pkg unpack nginx-1.10.0-0 --checksum 6677266088239cd5c8acf1d178d7bab71374baebc750e2a74e9b01c54bc7e686
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/html /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "nginx"]

WORKDIR /app

EXPOSE 80 443
