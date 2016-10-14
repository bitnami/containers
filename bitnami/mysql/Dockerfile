FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=5.7.14-r0 \
    BITNAMI_APP_NAME=mysql \
    BITNAMI_APP_USER=mysql

RUN bitnami-pkg unpack mysql-5.7.14-0 --checksum 0f4849fad700923179f3d8b6fbb762d2c218a5b1b4b044632c291eaec6cf212e
ENV PATH=/opt/bitnami/mysql/sbin:/opt/bitnami/mysql/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mysql"]

VOLUME ["/bitnami/mysql"]

EXPOSE 3306
