FROM gcr.io/stacksmith-images/minideb:jessie-r9
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=9.6.2-r0 \
    BITNAMI_APP_NAME=postgresql \
    BITNAMI_APP_USER=postgres


# System packages required
RUN install_packages libc6 libssl1.0.0 zlib1g libxml2 liblzma5 libedit2 libbsd0 libtinfo5 libxslt1.1

# Install postgresql
RUN bitnami-pkg unpack postgresql-9.6.2-0 --checksum b706396cc1a435741e4db319f8028d716047cc4d40e6b3418c16944f6661f90f
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs /

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 5432

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "postgresql"]
