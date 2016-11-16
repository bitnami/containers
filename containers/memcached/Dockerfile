FROM gcr.io/stacksmith-images/minideb:jessie-r2
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.4.33-r1 \
    BITNAMI_APP_NAME=memcached \
    BITNAMI_APP_USER=memcached

RUN bitnami-pkg unpack memcached-1.4.33-0 --checksum 42665a1c041a3d7fd989d67c07daca9a9a7d5f61739f4bf0ac2dbffb43459e75
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

EXPOSE 11211

COPY rootfs/ /

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "memcached"]
