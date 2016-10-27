FROM gcr.io/stacksmith-images/minideb:jessie-r0
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=9.6.1-r0 \
    BITNAMI_APP_NAME=postgresql \
    BITNAMI_APP_USER=postgres

RUN bitnami-pkg unpack postgresql-9.6.1-0 --checksum 7df40e7408cb28f6b50a1be64d4c57b09c8790ea210e376b4474a9d650c508ef
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 5432

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "postgresql"]
