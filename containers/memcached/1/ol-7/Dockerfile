FROM bitnami/oraclelinux-extras:7-r321
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libevent libselinux nss-softokn-freebl pcre
RUN bitnami-pkg unpack memcached-1.5.13-0 --checksum b43aeb1b3e4de445985acc0ea7fbba81a0e23f496d5fc57ed06e2129d37ee796

COPY rootfs /
ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.5.13-ol-7-r0" \
    MEMCACHED_CACHE_SIZE="64" \
    MEMCACHED_PASSWORD="" \
    MEMCACHED_USERNAME="root" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/memcached/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
