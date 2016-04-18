FROM gcr.io/stacksmith-images/ubuntu:14.04-r05
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=mariadb \
    BITNAMI_APP_VERSION=10.1.12-0 \
    BITNAMI_APP_CHECKSUM=9789082a1e01a4411198136477723288736d5ad5990403a208423b39369c8aac \
    BITNAMI_APP_USER=mysql

# Install supporting modules
RUN bitnami-pkg install base-functions-1.0.0-2 --checksum 9789082a1e01a4411198136477723288736d5ad5990403a208423b39369c8aac

# Install application
RUN bitnami-pkg unpack $BITNAMI_APP_NAME-$BITNAMI_APP_VERSION --checksum $BITNAMI_APP_CHECKSUM
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

# Setting entry point
COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "mariadb"]

# Exposing ports
EXPOSE 3306

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]
