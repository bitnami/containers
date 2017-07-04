FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libevent-2.0-5 libsasl2-2 sasl2-bin
RUN bitnami-pkg unpack memcached-1.4.39-0 --checksum 2248f1a4deeb504da17d8be98c003b82036b6723a1ef19790dd59ba9ac2da33c

COPY rootfs /

ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.4.39-r0" \
    MEMCACHED_PASSWORD="" \
    MEMCACHED_USERNAME="root" \
    PATH="/opt/bitnami/memcached/bin:$PATH"




EXPOSE 11211

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","memcached"]
