FROM gcr.io/stacksmith-images/ubuntu:14.04-r9
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=9.5.3-r4 \
    BITNAMI_APP_NAME=postgresql \
    BITNAMI_APP_USER=postgres

RUN bitnami-pkg unpack postgresql-9.5.3-5 --checksum d3fa42dc016331dfa864222d28ebae0eee0a130759102bf34fda7dd853cacb72
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "postgresql"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 5432
