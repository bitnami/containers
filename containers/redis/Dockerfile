FROM gcr.io/stacksmith-images/minideb:jessie-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.6-r1 \
    BITNAMI_APP_NAME=redis \
    BITNAMI_APP_USER=redis

# System packages required
RUN install_packages --no-install-recommends libc6

# Install redis
RUN bitnami-pkg unpack redis-3.2.6-0 --checksum 9f49ddb833750511a406e3a735bbb2a6969091ae395a6ddf35adcb1aef133098
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "redis"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 6379
