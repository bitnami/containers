FROM bitnami/minideb-extras:jessie-r17
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libevent-2.0-5 libsasl2-2 sasl2-bin
RUN bitnami-pkg unpack memcached-1.4.38-0 --checksum f4f9c4daac62e4b170f62ecf10076d8145736407b5c98bfc9262a176506bae50

COPY rootfs /

ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.4.38-r0" \
    MEMCACHED_PASSWORD="" \
    MEMCACHED_USERNAME="root" \
    PATH="/opt/bitnami/memcached/bin:$PATH"




EXPOSE 11211

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","memcached"]
