FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=5.7.14-r0 \
    BITNAMI_APP_NAME=mysql \
    BITNAMI_APP_USER=mysql

RUN bitnami-pkg unpack mysql-5.7.14-0 --checksum 9bf34ea35852b0459c57d1a37cead66c9417e02a3eae8c3f77f70b800592d825
ENV PATH=/opt/bitnami/mysql/sbin:/opt/bitnami/mysql/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mysql"]

VOLUME ["/bitnami/mysql"]

EXPOSE 3306
