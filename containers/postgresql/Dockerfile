FROM gcr.io/stacksmith-images/ubuntu:14.04-r07
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=9.5.3-r1 \
    BITNAMI_APP_NAME=postgresql \
    BITNAMI_APP_USER=postgres

RUN bitnami-pkg unpack postgresql-9.5.3-3 --checksum b1f8e2d9d8848453153c1059e2c4322d866b79fda4010590520e79796f628127
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "postgresql"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 5432
