FROM gcr.io/stacksmith-images/ubuntu:14.04-r07
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.4.25-r0 \
    BITNAMI_APP_NAME=memcached \
    BITNAMI_APP_USER=memcached

RUN bitnami-pkg unpack memcached-1.4.25-1 --checksum 6e9fbb0997e960fb870f8b4861658d5c057646c511d7d9ea88eb872f3546581f
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "memcached"]

EXPOSE 11211
