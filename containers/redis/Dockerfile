FROM gcr.io/stacksmith-images/minideb:jessie-r4
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.5-r2 \
    BITNAMI_APP_NAME=redis \
    BITNAMI_APP_USER=redis

# System packages required
RUN install_packages --no-install-recommends libc6

# Install redis
RUN bitnami-pkg unpack redis-3.2.5-1 --checksum 725fc7c3d80da24d72d01a01ebc94dad74167d7f342040c8767eac83ad3e7c85
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "redis"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 6379
