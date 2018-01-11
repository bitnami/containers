FROM bitnami/minideb-extras:jessie-r23
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libevent-2.0-5 libsasl2-2 sasl2-bin
RUN bitnami-pkg unpack memcached-1.5.4-1 --checksum d298c664386bad60c55a8c717552af81028f0d8dbb977c8ed65294c227b6fd33

COPY rootfs /

ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.5.4-r1" \
    MEMCACHED_CACHE_SIZE="64" \
    MEMCACHED_PASSWORD="" \
    MEMCACHED_USERNAME="root" \
    PATH="/opt/bitnami/memcached/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
