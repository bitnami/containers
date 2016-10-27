FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=5.7.16-r1 \
    BITNAMI_APP_NAME=mysql \
    BITNAMI_APP_USER=mysql

RUN bitnami-pkg unpack mysql-5.7.16-1 --checksum 21040736cae8196643260ecbae8552a9079fae888f6d956bb4ed1cddc4679d88
ENV PATH=/opt/bitnami/mysql/sbin:/opt/bitnami/mysql/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mysql"]

VOLUME ["/bitnami/mysql"]

EXPOSE 3306
