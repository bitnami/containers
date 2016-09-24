FROM gcr.io/stacksmith-images/ubuntu:14.04-r10
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=7.0.11-r0 \
    BITNAMI_APP_NAME=php-fpm \
    BITNAMI_APP_USER=daemon

RUN bitnami-pkg unpack php-7.0.11-1 --checksum cc9129523269e86728eb81ac489c65996214f22c6447bbff4c2306ec4be3c871
RUN mkdir -p /bitnami && ln -sf /bitnami/php /bitnami/php-fpm
ENV PATH=/opt/bitnami/php/sbin:/opt/bitnami/php/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "php"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

WORKDIR /app

EXPOSE 9000
