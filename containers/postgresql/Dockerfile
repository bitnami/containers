FROM gcr.io/stacksmith-images/ubuntu:14.04-r07
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=9.5.3-r0 \
    BITNAMI_APP_NAME=postgresql \
    BITNAMI_APP_USER=postgres

RUN bitnami-pkg unpack postgresql-9.5.3-1 --checksum 458ac1d3beb5b250af17ee7b829c061867d770b6655379528c2b2339f2e426ef
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "postgresql"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 5432
