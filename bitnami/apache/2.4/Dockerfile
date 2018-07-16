FROM bitnami/minideb-extras:jessie-r105
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libgmp10 libgnutls-deb0-28 libhogweed2 libldap-2.4-2 libnettle4 libp11-kit0 libpcre3 libsasl2-2 libssl1.0.0 libtasn1-6 zlib1g
RUN bitnami-pkg unpack apache-2.4.34-0 --checksum be3de7b24e809b3678f18da08ab220cbca09b458e895d5d6f491afc6f333ebe1
RUN ln -sf /opt/bitnami/apache/htdocs /app

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="apache" \
    BITNAMI_IMAGE_VERSION="2.4.34-debian-8-r0" \
    PATH="/opt/bitnami/apache/bin:$PATH"

EXPOSE 80 443

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
