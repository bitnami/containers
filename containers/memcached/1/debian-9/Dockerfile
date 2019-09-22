FROM bitnami/minideb-extras:stretch-r484
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libevent-2.0-5 libsasl2-2 libsasl2-modules sasl2-bin
RUN bitnami-pkg unpack memcached-1.5.18-1 --checksum 0de1f60c8e62c3c072903452952db87b4efb81b4f942d0e268b036c5b1c5d5f2

COPY rootfs /
ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.5.18-debian-9-r5" \
    MEMCACHED_CACHE_SIZE="64" \
    MEMCACHED_PASSWORD="" \
    MEMCACHED_USERNAME="root" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/memcached/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
