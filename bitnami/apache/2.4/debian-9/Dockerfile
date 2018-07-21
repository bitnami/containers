FROM bitnami/minideb-extras:stretch-r84
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libgmp10 libgnutls30 libhogweed4 libidn11 libldap-2.4-2 libnettle6 libp11-kit0 libpcre3 libsasl2-2 libssl1.1 libtasn1-6 zlib1g
RUN bitnami-pkg unpack apache-2.4.34-0 --checksum 56464e0931e05066036f43ef56a7c5c3d2a5ddad85eebd62748e3223e6289ace
RUN ln -sf /opt/bitnami/apache/htdocs /app

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="apache" \
    BITNAMI_IMAGE_VERSION="2.4.34-debian-9-r5" \
    PATH="/opt/bitnami/apache/bin:$PATH"

EXPOSE 80 443

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","apache"]
