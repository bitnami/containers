FROM gcr.io/stacksmith-images/minideb:jessie-r11
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.4.35-r0 \
    BITNAMI_APP_NAME=memcached \
    PATH=/opt/bitnami/memcached/bin:$PATH

# System packages required
RUN install_packages libevent-2.0-5 libsasl2-2 libc6 sasl2-bin

# Install memcached
RUN bitnami-pkg unpack memcached-1.4.35-0 --checksum 33cf5be7752b11fcd6f34234d9cfe0a47d68a7f9bfc5c3ab2d777fcc449c4772

COPY rootfs/ /

ENV MEMCACHED_USERNAME=root \
    MEMCACHED_PASSWORD=

EXPOSE 11211

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "memcached"]
