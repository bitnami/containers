FROM gcr.io/stacksmith-images/ubuntu:14.04-r10
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.4.32-r0 \
    BITNAMI_APP_NAME=memcached \
    BITNAMI_APP_USER=memcached

RUN bitnami-pkg unpack memcached-1.4.32-1 --checksum d3496e140ff99b5df3357ea1e026693e9d5c16f99f3fc7ae0346e0eebf01f64e
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "memcached"]

EXPOSE 11211
