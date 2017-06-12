FROM bitnami/minideb-extras:jessie-r17
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libevent-2.0-5 libsasl2-2 sasl2-bin
RUN bitnami-pkg unpack memcached-1.4.37-0 --checksum 6d13115bed8cfde2b8dd1713290df3ea9dc4528ed0bbac6c93382689938a4ee4

COPY rootfs /

ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.4.37-r0" \
    MEMCACHED_PASSWORD="" \
    MEMCACHED_USERNAME="root" \
    PATH="/opt/bitnami/memcached/bin:$PATH"




EXPOSE 11211

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","memcached"]
