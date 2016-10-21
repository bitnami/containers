FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=5.7.16-r0 \
    BITNAMI_APP_NAME=mysql \
    BITNAMI_APP_USER=mysql

RUN bitnami-pkg unpack mysql-5.7.16-0 --checksum 9c22b4874af476dd795072cded69c981b195e28d0f4a66e7fe58dca8d4100272
ENV PATH=/opt/bitnami/mysql/sbin:/opt/bitnami/mysql/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mysql"]

VOLUME ["/bitnami/mysql"]

EXPOSE 3306
