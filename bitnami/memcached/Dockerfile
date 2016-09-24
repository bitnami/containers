FROM gcr.io/stacksmith-images/ubuntu:14.04-r10
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.4.25-r6 \
    BITNAMI_APP_NAME=memcached \
    BITNAMI_APP_USER=memcached

RUN bitnami-pkg unpack memcached-1.4.25-3 --checksum 202b6500474b9abe66b06b16ea464ac5629f4f9c7e0247b8a9d2a8330152916b
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "memcached"]

EXPOSE 11211
