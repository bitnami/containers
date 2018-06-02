FROM bitnami/minideb-extras:jessie-r65
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libgmp10 libgnutls-deb0-28 libhogweed2 libldap-2.4-2 libnettle4 libp11-kit0 libpcre3 libsasl2-2 libssl1.0.0 libtasn1-6 zlib1g
RUN bitnami-pkg unpack apache-2.4.33-3 --checksum 55bc664737e2ff9d534468088424ee4b04e770e67800e317c9db5b1e58cf2ffe
RUN ln -sf /opt/bitnami/apache/htdocs /app

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="apache" \
    BITNAMI_IMAGE_VERSION="2.4.33-r35" \
    PATH="/opt/bitnami/apache/bin:$PATH"

EXPOSE 80 443

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
