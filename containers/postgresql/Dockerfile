FROM gcr.io/stacksmith-images/minideb:jessie-r5
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=9.6.1-r2 \
    BITNAMI_APP_NAME=postgresql \
    BITNAMI_APP_USER=postgres


# System packages required
RUN install_packages --no-install-recommends libc6 libssl1.0.0 zlib1g libxml2 liblzma5 libedit2 libbsd0 libtinfo5 libxslt1.1

# Install postgresql
RUN bitnami-pkg unpack postgresql-9.6.1-1 --checksum af594552c2e9644bc51539414ed297701d347be450cd2b9c14a1082ef8f56e69
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs /

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 5432

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "postgresql"]
