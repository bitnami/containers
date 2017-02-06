FROM gcr.io/stacksmith-images/minideb:jessie-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.7-r0 \
    BITNAMI_APP_NAME=redis \
    BITNAMI_APP_USER=redis

# System packages required
RUN install_packages libc6

# Install redis
RUN bitnami-pkg unpack redis-3.2.7-0 --checksum 4fb9d55b41f147ceb7ab381bec68aa88e330710e7eb0a96963297bddb058cb66
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "redis"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 6379
