FROM bitnami/minideb-extras:jessie-r15
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libevent-2.0-5 libsasl2-2 sasl2-bin
RUN bitnami-pkg unpack memcached-1.4.36-0 --checksum b6925da994329069055808165bae36f8e833e7f78be9b1c8ff494ac0d84d713a

COPY rootfs /

ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.4.36-r3" \
    MEMCACHED_PASSWORD="" \
    MEMCACHED_USERNAME="root" \
    PATH="/opt/bitnami/memcached/bin:$PATH"


EXPOSE 11211

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","memcached"]
