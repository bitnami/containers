FROM bitnami/minideb-extras:jessie-r15
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.4.36-r2 \
    BITNAMI_APP_NAME=memcached \
    PATH=/opt/bitnami/memcached/bin:$PATH

# System packages required
RUN install_packages libevent-2.0-5 libsasl2-2 libc6 sasl2-bin

# Install memcached
RUN bitnami-pkg unpack memcached-1.4.36-0 --checksum b6925da994329069055808165bae36f8e833e7f78be9b1c8ff494ac0d84d713a

COPY rootfs/ /

ENV MEMCACHED_USERNAME=root \
    MEMCACHED_PASSWORD=

EXPOSE 11211

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "memcached"]
