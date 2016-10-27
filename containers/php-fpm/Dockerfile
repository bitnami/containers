FROM gcr.io/stacksmith-images/minideb:jessie-r1
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=7.0.12-r0 \
    BITNAMI_APP_NAME=php-fpm \
    BITNAMI_APP_USER=daemon

RUN bitnami-pkg unpack php-7.0.12-1 --checksum d6e73b25677e4beae79c6536b1f7e6d9f23c153d62b586f16e334782a6868eb2
RUN mkdir -p /bitnami && ln -sf /bitnami/php /bitnami/php-fpm
ENV PATH=/opt/bitnami/php/sbin:/opt/bitnami/php/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "php"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

WORKDIR /app

EXPOSE 9000
