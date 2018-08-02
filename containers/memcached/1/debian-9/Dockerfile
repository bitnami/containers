FROM bitnami/minideb-extras:stretch-r94
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libevent-2.0-5 libsasl2-2 libsasl2-modules sasl2-bin
RUN bitnami-pkg unpack memcached-1.5.9-1 --checksum 0a8486c1b2e7a70bbce2b870ad78b0659e880372dafa868f24fb708e25f9e820

COPY rootfs /
ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.5.9-debian-9-r20" \
    MEMCACHED_CACHE_SIZE="64" \
    MEMCACHED_PASSWORD="" \
    MEMCACHED_USERNAME="root" \
    PATH="/opt/bitnami/memcached/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
