FROM bitnami/minideb-extras:stretch-r75
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libgmp10 libgnutls30 libhogweed4 libidn11 libldap-2.4-2 libnettle6 libp11-kit0 libpcre3 libsasl2-2 libssl1.1 libtasn1-6 zlib1g
RUN bitnami-pkg unpack apache-2.4.33-4 --checksum 6cc79624d133577b8081ddcfa1d1bf5749bbd25fe372ff2a72a6eb4d38a231c6
RUN ln -sf /opt/bitnami/apache/htdocs /app

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="apache" \
    BITNAMI_IMAGE_VERSION="2.4.33-debian-9-r5" \
    PATH="/opt/bitnami/apache/bin:$PATH"

EXPOSE 80 443

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
