FROM gcr.io/stacksmith-images/ubuntu:14.04-r9
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=7.0.6-r1 \
    BITNAMI_APP_NAME=php-fpm \
    BITNAMI_APP_USER=daemon

RUN bitnami-pkg unpack php-7.0.8-0 --checksum afc462c63a44a1abe5c130d1fdfad3ef88989b8b75d782c90538a0d1acaff4ee
RUN mkdir -p /bitnami && ln -sf /bitnami/php /bitnami/php-fpm
ENV PATH=/opt/bitnami/php/sbin:/opt/bitnami/php/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "php"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

WORKDIR /app

EXPOSE 9000
