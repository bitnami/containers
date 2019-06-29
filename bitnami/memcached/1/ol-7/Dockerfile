FROM bitnami/oraclelinux-extras:7-r382
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libevent libselinux nss-softokn-freebl pcre
RUN bitnami-pkg unpack memcached-1.5.16-0 --checksum 05c91f608bb09648c0e6cb62ae50074aca1554e7ec2d4deadf363d5001d1c29b

COPY rootfs /
ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.5.16-ol-7-r36" \
    MEMCACHED_CACHE_SIZE="64" \
    MEMCACHED_PASSWORD="" \
    MEMCACHED_USERNAME="root" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/memcached/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
