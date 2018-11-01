FROM bitnami/minideb-extras:stretch-r184
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libevent-2.0-5 libsasl2-2 libsasl2-modules sasl2-bin
RUN bitnami-pkg unpack memcached-1.5.11-1 --checksum 999da1dacfcbaecf52333771555707486e0235dee3003da041011305b80677da

COPY rootfs /
ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.5.11-debian-9-r22" \
    MEMCACHED_CACHE_SIZE="64" \
    MEMCACHED_PASSWORD="" \
    MEMCACHED_USERNAME="root" \
    PATH="/opt/bitnami/memcached/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
