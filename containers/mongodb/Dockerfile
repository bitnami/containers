FROM gcr.io/stacksmith-images/ubuntu:14.04-r05
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_VERSION=3.2.1-1 \
    BITNAMI_APP_CHECKSUM=e44c4f6f1cd2142cf67190e69e92ad76167b7d371e0a9dcc00b148965da394cd \
    BITNAMI_APP_USER=mongo

COPY pkg-cache/ /tmp/bitnami/pkg/cache/

# Install supporting modules
RUN bitnami-pkg install base-functions-1.0.0-2 --checksum 9789082a1e01a4411198136477723288736d5ad5990403a208423b39369c8aac

# Install application
RUN bitnami-pkg unpack $BITNAMI_APP_NAME-$BITNAMI_APP_VERSION --checksum $BITNAMI_APP_CHECKSUM
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

# Setting entry point
COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "mongodb"]

# Exposing ports
EXPOSE 27017

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]
