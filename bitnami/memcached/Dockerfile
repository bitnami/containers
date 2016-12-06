FROM gcr.io/stacksmith-images/minideb:jessie-r4
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.4.33-r2 \
    BITNAMI_APP_NAME=memcached \
    BITNAMI_APP_USER=memcached

# System packages required
RUN install_packages libevent-2.0-5 libsasl2-2 libc6 sasl2-bin

# Install memcached
RUN bitnami-pkg unpack memcached-1.4.33-1 --checksum 55dafdf04a51a7b6b0d53deaf3c078a523db232123f7ab7089fe207836729627

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

EXPOSE 11211

COPY rootfs/ /

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "memcached"]
