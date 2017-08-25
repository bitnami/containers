FROM bitnami/minideb-extras:jessie-r21
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libevent-2.0-5 libsasl2-2 sasl2-bin
RUN bitnami-pkg unpack memcached-1.5.1-0 --checksum a3c0d6da61b8f8acba06d2d7b7d69aed688c962bae000aff833f27588736cfb0

COPY rootfs /

ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.5.1-r0" \
    MEMCACHED_PASSWORD="" \
    MEMCACHED_USERNAME="root" \
    PATH="/opt/bitnami/memcached/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
