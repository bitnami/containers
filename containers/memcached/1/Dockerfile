FROM gcr.io/stacksmith-images/minideb:jessie-r10
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.4.34-r0 \
    BITNAMI_APP_NAME=memcached \
    PATH=/opt/bitnami/memcached/bin:$PATH

# System packages required
RUN install_packages libevent-2.0-5 libsasl2-2 libc6 sasl2-bin

# Install memcached
RUN bitnami-pkg unpack memcached-1.4.34-0 --checksum 2442388511ae464ee2fc32c896afb5427f06610b9e75f1a8662436fa304f5bf4

COPY rootfs/ /

ENV MEMCACHED_USERNAME=root \
    MEMCACHED_PASSWORD=

EXPOSE 11211

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "memcached"]
